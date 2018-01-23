module Krudmin
  class SearchForm
    class CalendarFilter
      include SearchPhrasesSupport

      def self.for(field, search_criteria, model_class)
        new(field, search_criteria, model_class).filters
      end

      attr_reader :field, :search_criteria, :model_class
      def initialize(field, search_criteria, model_class)
        @field = field
        @search_criteria = search_criteria
        @model_class = model_class
      end

      def filters
        [
          from_filter_phrase,
          to_filter_phrase,
        ].compact
      end

      private

      def from_filter_phrase
        if from_date.present?
          [
            "`#{attribute_name}`",
            search_phrase_for(from_date_key),
            "< #{from_date} >",
          ].join(" ")
        end
      end

      def to_filter_phrase
        if to_date.present?
          [
            "`#{attribute_name}`",
            search_phrase_for(to_date_key),
            "< #{to_date} >",
          ].join(" ")
        end
      end

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
