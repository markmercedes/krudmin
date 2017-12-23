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
    }.freeze

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
        next if search_criteria[field.to_s].blank?
        [
          "`#{model_class.human_attribute_name(field)}`",
          SEARCH_PREDICATES.find{|pre| pre.last == search_criteria["#{field.to_s}_options"].to_sym }.first,
          "< #{search_criteria[field.to_s]} >"
        ].join(' ')
      }.compact
    end

    def fill_with(values)
      @search_criteria = HashWithIndifferentAccess.new(values)

      fields_with_values = search_criteria.keys.reject{|k| k.end_with?("_options")}

      @params = fields_with_values.inject({}) do |hash, key|
        criteria = search_criteria["#{key}_options"]
        hash["#{key}_#{criteria}"] = search_criteria[key]
        attrs[key] = search_criteria[key]
        attrs["#{key}_options"] = criteria
        hash
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
