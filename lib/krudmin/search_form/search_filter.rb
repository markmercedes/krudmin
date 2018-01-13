module Krudmin
  class SearchForm
    class SearchFilter
      include Krudmin::SearchForm::SearchPhrasesSupport
      include Krudmin::SearchForm::SearchInputTypeSupport

      def self.for(field, search_criteria, model_class)
        new(field, search_criteria, model_class).filters
      end

      def calendar_filter_for(field)
        Krudmin::SearchForm::CalendarFilter.for(field, search_criteria, model_class)
      end

      attr_reader :field, :search_criteria, :model_class
      def initialize(field, search_criteria, model_class)
        @field, @search_criteria, @model_class = field, search_criteria, model_class
      end

      def filters
        if input_type_for(field) == Krudmin::Fields::Boolean
          return unless search_criteria["#{field}_options"].present? && search_criteria[field].present?
          [
            search_phrase_for(field),
            "`#{model_class.human_attribute_name(field)}`"
          ].join(' ')
        elsif input_type_for(field) == Krudmin::Fields::DateTime
          calendar_filter_for(field)
        else
          return unless search_criteria["#{field}_options"].present? && search_criteria[field].present?
          real_field = real_field_for(field)
          [
            "`#{model_class.human_attribute_name(real_field)}`",
            search_phrase_for(field),
            "< #{search_criteria[field.to_s]} >"
          ].join(' ')
        end
      end

      private

      def attribute_name
        @attribute_name ||= model_class.human_attribute_name(field)
      end

      def from_date_key
        @from_date_key ||= "#{field}__from"
      end

      def to_date_key
        @to_date_key ||= "#{field}__to"
      end

      def from_date
        @from_date ||= search_criteria[from_date_key]
      end

      def to_date
        @to_date ||= search_criteria[to_date_key]
      end
    end
  end
end
