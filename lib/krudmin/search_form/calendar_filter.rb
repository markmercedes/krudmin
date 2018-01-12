module Krudmin
  class SearchForm
    class CalendarFilter
      include SearchPhrasesSupport

      def self.for(field, search_criteria, model_class)
        new(field, search_criteria, model_class).filters
      end

      attr_accessor :field, :search_criteria, :model_class
      def initialize(field, search_criteria, model_class)
        @field, @search_criteria, @model_class = field, search_criteria, model_class
      end

      def filters
        [
          from_filter_phrase,
          to_filter_phrase
        ].compact
      end

      private

      def from_filter_phrase
        [
          "`#{attribute_name}`",
          search_phrase_for(from_date_key),
          "< #{from_date} >"
        ].join(' ') if from_date.present?
      end

      def to_filter_phrase
        [
          "`#{attribute_name}`",
          search_phrase_for(to_date_key),
          "< #{to_date} >"
        ].join(' ') if to_date.present?
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
