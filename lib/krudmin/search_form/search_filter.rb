module Krudmin
  class SearchForm
    class SearchFilter
      include Krudmin::SearchForm::SearchPhrasesSupport
      include Krudmin::SearchForm::SearchInputTypeSupport

      def self.for(field, search_criteria, model_class)
        new(field, search_criteria, model_class).filters
      end

      attr_reader :field, :search_criteria, :model_class
      def initialize(field, search_criteria, model_class)
        @field, @search_criteria, @model_class = field, search_criteria, model_class
      end

      def filters
        return unless valid_field?

        if input_type == Krudmin::Fields::Boolean
          boolean_filter_for(field)
        elsif input_type == Krudmin::Fields::DateTime
          calendar_filter_for(field)
        else
          regular_filter_for(field)
        end
      end

      private

      def valid_field?
        input_type == Krudmin::Fields::DateTime || (search_criteria["#{field}_options"].present? && search_criteria[field].present?)
      end

      def input_type
        @input_type ||= input_type_for(field)
      end

      def calendar_filter_for(field)
        Krudmin::SearchForm::CalendarFilter.for(field, search_criteria, model_class)
      end

      def boolean_filter_for(field)
        [
          search_phrase_for(field),
          "`#{model_class.human_attribute_name(field)}`"
        ].join(' ')
      end

      def regular_filter_for(field)
        [
          "`#{model_class.human_attribute_name(real_field_for(field))}`",
          search_phrase_for(field),
          "< #{search_criteria[field.to_s]} >"
        ].join(' ')
      end
    end
  end
end
