module Krudmin
  class SearchForm
    attr_reader :attrs, :fields, :enhanced_fields, :all_fields, :params, :search_criteria, :model_class, :s

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

    def input_type_for(field)
      case model_class.type_for_attribute(field.to_s).type
      when :decimal, :integer, :bigint, :float
        Krudmin::Fields::Number
      when :date, :datetime, :timestamp
        Krudmin::Fields::DateTime
      when :boolean
        Krudmin::Fields::Boolean
      else
        Krudmin::Fields::String
      end
    end

    def search_predicates_for(field)
      input_type_for(field)::SEARCH_PREDICATES.map{|type| SEARCH_PREDICATES.find{|label, key| type == key}}
    end

    def initialize(fields, model_class)
      @model_class = model_class

      @enhanced_fields = (fields.map do |field|
        if input_type_for(field) == Krudmin::Fields::DateTime
          ["#{field}__from".to_sym, "#{field}__to".to_sym]
        else
          field
        end
      end).flatten

      fields_options = @enhanced_fields.map{|field| "#{field}_options".to_sym}

      @all_fields = [@enhanced_fields, fields_options].flatten

      @fields = fields

      @attrs = HashWithIndifferentAccess.new
      @params = {}
      @search_criteria = {}
    end

    def filters
      fields.map{|field|
        if input_type_for(field) == Krudmin::Fields::Boolean
          next unless search_criteria["#{field}_options"].present? && search_criteria[field].present?
          [
            search_phrase_for(field),
            "`#{model_class.human_attribute_name(field)}`"
          ].join(' ')
        elsif input_type_for(field) == Krudmin::Fields::DateTime
          calendar_filter_for(field)
        else
          next unless search_criteria["#{field}_options"].present? && search_criteria[field].present?
          real_field = real_field_for(field)
          [
            "`#{model_class.human_attribute_name(real_field)}`",
            search_phrase_for(field),
            "< #{search_criteria[field.to_s]} >"
          ].join(' ')
        end
      }.compact.flatten
    end



    def fill_with(values)
      @search_criteria = HashWithIndifferentAccess.new(values)

      fields_with_values = search_criteria.keys.reject{|k| k.end_with?("_options")}

      @params = fields_with_values.inject({}) do |hash, key|
        criteria = search_criteria["#{key}_options"]
        unless criteria.blank?
          if input_type_for(real_field_for(key)) == Krudmin::Fields::DateTime
            attrs[key] = Date.parse(search_criteria[key])

            if key.to_s.end_with?("__to")
              attrs[key] = attrs[key].end_of_day
              hash["#{real_field_for(key)}_#{criteria}"] = attrs[key]
            else
              attrs[key] = attrs[key].beginning_of_day
              hash["#{real_field_for(key)}_#{criteria}"] = attrs[key]
            end

          else
            attrs[key] = search_criteria[key]
            hash["#{key}_#{criteria}"] = search_criteria[key]
          end
          attrs["#{key}_options"] = criteria
        end
        hash
      end
      @params
    end

    def sort_with(sorting_expression)
      set_sorting(sorting_expression) if sorting_expression.is_a?(String)
      @params
    end

    private

    def real_field_for(field)
      field.to_s.gsub('__from', '').gsub('__to', '')
    end

    def calendar_filter_for(field)
      from = search_criteria["#{field}__from"]
      to = search_criteria["#{field}__to"]

      result = []

      if from.present?
        result.push(
          [
            "`#{model_class.human_attribute_name(field)}`",
            search_phrase_for("#{field}__from"),
            "< #{search_criteria["#{field}__from"]} >"
          ].join(' ')
        )
      end

      if to.present?
        result.push(
          [
            "`#{model_class.human_attribute_name(field)}`",
            search_phrase_for("#{field}__to"),
            "< #{search_criteria["#{field}__to"]} >"
          ].join(' ')
        )
      end

      result
    end

    def search_phrase_for(field)
      SEARCH_PREDICATES.find{|pre| pre.last == search_criteria["#{field}_options"].to_sym }.first.join_phrase
    end

    def set_sorting(sorting_expression)
      if sorting_expression.present?
        @params[:s] = sorting_expression
        @s = sorting_expression
      end
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
