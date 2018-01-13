require_relative "search_form/search_phrases_support"
require_relative "search_form/search_input_type_support"
require_relative "search_form/calendar_filter"
require_relative "search_form/search_filter"

module Krudmin
  class SearchForm
    attr_reader :fields, :search_criteria, :sorting_expression, :model_class

    alias_method :s, :sorting_expression

    include ActiveModel::Model
    include Krudmin::SearchForm::SearchPhrasesSupport
    include Krudmin::SearchForm::SearchInputTypeSupport

    def initialize(fields, model_class, search_by: {}, order_by: nil)
      @fields = fields
      @model_class = model_class
      @search_criteria = i_hash(search_by)
      @sorting_expression = order_by
    end

    def enhanced_fields
      @enhanced_fields ||= fields.map{|field|
        input_type_for(field).search_config_for(field)
      }.flatten
    end

    def filters
      fields.map{|field|
        Krudmin::SearchForm::SearchFilter.for(field, search_criteria, model_class)
      }.compact.flatten
    end

    def form_attributes
      @form_attributes ||= fields_with_values.inject(i_hash) {|hash, key|
                    hash.merge(key => search_criteria_for(key, search_criteria[key]),
                              "#{key}_options" => search_criteria["#{key}_options"])
                 }
    end

    def params
      @params ||= begin
        _params = fields_with_values.inject(i_hash) do |hash, key|
          criteria = search_criteria["#{key}_options"]

          hash["#{real_field_for(key)}_#{criteria}"] = form_attributes[key] unless criteria.blank?

          hash
        end

        apply_sorting_on(_params)
      end
    end

    private

    def method_missing(method, *args, &block)
      return "" if method == :""
      return form_attributes[method] if all_fields.include?(method)

      super
    end

    def apply_sorting_on(params)
      params[:s] = sorting_expression if sorting_expression.present? && sorting_expression.is_a?(String)

      params
    end

    def all_fields
      @all_fields ||= [enhanced_fields, fields_options].flatten
    end

    def fields_options
      @fields_options ||= enhanced_fields.map{|field| "#{field}_options".to_sym}
    end

    def fields_with_values
      search_criteria.keys.reject{|k| k.end_with?("_options")}
    end

    def i_hash(value = {})
      HashWithIndifferentAccess.new(value)
    end
  end
end
