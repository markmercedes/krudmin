module Krudmin
  class SearchForm
    attr_reader :attrs, :fields, :all_fields, :params, :search_criteria, :model_class

    include ActiveModel::Model

    SEARCH_PREDICATES  = {
      "contains" => :cont,
      "equals" => :eq,
      "not equal to" => :not_eq,
      "matches" => :matches,
      "doesn't match" => :does_not_match,
      "less than" => :lt,
      "less than or equal to" => :lteq,
      "greater than" => :gt,
      "greater than or equal to" => :gteq,
      "doesn't contain" => :not_cont,
      "starts with" => :start,
      "doesn't start with" => :not_start,
      "ends with" => :end,
      "doesn't end with" => :not_end,
      "yes" => :true,
      "no" => :false
    }.freeze

    TYPE_PREDICATES = {
      numeric: [:eq, :not_eq, :lt, :lteq, :gt, :gteq],
      calendar: [:eq, :not_eq, :lt, :lteq, :gt, :gteq],
      string: [:cont, :eq, :matches, :does_not_match, :start, :not_start, :end, :not_end],
      boolean: [:true, :false],
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
      type_predicates = TYPE_PREDICATES[input_type_for(field)]
      SEARCH_PREDICATES.select{|label, key| type_predicates.include?(key) }
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

    def search_predicates
      SEARCH_PREDICATES
    end

    def filters
      fields.map{|field|
        next unless search_criteria["#{field}_options"].present? && search_criteria[field].present?
        [
          "`#{model_class.human_attribute_name(field)}`",
          SEARCH_PREDICATES.find{|pre| pre.last == search_criteria["#{field}_options"].to_sym }.first,
          "< #{search_criteria[field.to_s]} >"
        ].join(' ')
      }.compact
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
