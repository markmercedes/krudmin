module Krudmin
  class SearchForm
    attr_reader :attrs, :fields, :all_fields, :params, :search_criteria, :model_class

    include ActiveModel::Model

    class SearchTranslation
      attr_accessor :str
      def initialize(str)
        @str = str
      end

      def to_s
        I18n.t("krudmin.search.#{@str}")
      end

      def join_phrase
        I18n.t("krudmin.search.join_phrases.#{@str}")
      end
    end

    def self.translation_for(key)
      SearchTranslation.new(key)
    end

    SEARCH_PREDICATES = {
      translation_for(:contains) => :cont,
      translation_for(:equals) => :eq,
      translation_for(:not_equal_to) => :not_eq,
      translation_for(:matches) => :matches,
      translation_for(:doesnt_match) => :does_not_match,
      translation_for(:less_than) => :lt,
      translation_for(:less_than_or_equal_to) => :lteq,
      translation_for(:greater_than) => :gt,
      translation_for(:greater_than_or_equal_to) => :gteq,
      translation_for(:doesnt_contain) => :not_cont,
      translation_for(:starts_with) => :start,
      translation_for(:doesnt_start_with) => :not_start,
      translation_for(:ends_with) => :end,
      translation_for(:doesnt_end_with) => :not_end,
      translation_for(:yes) => :true,
      translation_for(:no) => :false
    }.freeze

    TYPE_PREDICATES = {
      numeric: [:eq, :not_eq, :lt, :lteq, :gt, :gteq],
      calendar: [:eq, :not_eq, :lt, :lteq, :gt, :gteq],
      string: [:cont, :eq, :matches, :does_not_match, :start, :not_start, :end, :not_end],
      boolean: [:true, :false],
    }.freeze

    LABELIZED_TYPE_PREDICATES = TYPE_PREDICATES.inject({}) {|hash, type|
        hash[type.first] = SEARCH_PREDICATES.select{|label, key| type.last.include?(key) }
        hash
      }.freeze

    def input_type_for(field)
      case model_class.type_for_attribute(field.to_s).type
      when :decimal, :integer, :bigint, :float
        :numeric
      when :date, :datetime, :timestamp
        :calendar
      when :boolean
        :boolean
      else
        :string
      end
    end

    def search_predicates_for(field)
      LABELIZED_TYPE_PREDICATES[input_type_for(field)]
    end

    def initialize(fields, model_class)
      @model_class = model_class

      fields_options = fields.map{|field| "#{field}_options".to_sym}

      @fields = fields

      @all_fields = [fields, fields_options].flatten

      @attrs = HashWithIndifferentAccess.new
      @params = {}
      @search_criteria = {}
    end

    def seach_filter_label_for(field)
    end

    def filters
      fields.map{|field|
        next unless search_criteria["#{field}_options"].present? && search_criteria[field].present?
        if input_type_for(field) == :boolean
          [
            search_phrase_for(field),
            "`#{model_class.human_attribute_name(field)}`"
          ].join(' ')
        else
          [
            "`#{model_class.human_attribute_name(field)}`",
            search_phrase_for(field),
            "< #{search_criteria[field.to_s]} >"
          ].join(' ')
        end
      }.compact
    end

    def search_phrase_for(field)
      SEARCH_PREDICATES.find{|pre| pre.last == search_criteria["#{field}_options"].to_sym }.first.join_phrase
    end

    def fill_with(values)
      @search_criteria = HashWithIndifferentAccess.new(values)

      fields_with_values = search_criteria.keys.reject{|k| k.end_with?("_options")}

      @params = fields_with_values.inject({}) do |hash, key|
        criteria = search_criteria["#{key}_options"]
        unless criteria.blank?
          hash["#{key}_#{criteria}"] = search_criteria[key]
          if input_type_for(key) == :calendar
            attrs[key] = Date.parse(search_criteria[key])
          else
            attrs[key] = search_criteria[key]
          end
          attrs["#{key}_options"] = criteria
        end
        hash
      end

      @params
    end

    def method_missing(method, *args, &block)
      return "" if method == :""
      if method.to_s.end_with?('=')
        return attrs[method.to_s.gsub('=', '')] = args.first if all_fields.include?(method.to_s.gsub('=', '').to_sym)
      else
        return attrs[method] if all_fields.include?(method)
      end

      super
    end
  end
end
