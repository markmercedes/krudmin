require_relative "../presenters/date_field_presenter"

module Krudmin
  module Fields
    class Date < Base
      SEARCH_PREDICATES = [:eq, :not_eq, :lt, :lteq, :gt, :gteq]
      DEFAULT_VALUE = "-".freeze
      PRESENTER = Krudmin::Presenters::DateFieldPresenter

      def data
        @data ||= super&.in_time_zone(timezone)
      end

      def value
        if data
          I18n.localize(
            data.to_date,
            format: format,
            default: data,
          )
        end
      end

      def to_s
        value || default_value
      end

      def timezone
        options.fetch(:timezone) { Time.zone.name }
      end

      def format
        options.fetch(:format, :default)
      end

      def self.search_config_for(field)
        ["#{field}__from".to_sym, "#{field}__to".to_sym]
      end

      def self.search_criteria_for(key, raw_value)
        value = ::Date.parse(raw_value)

        if key.to_s.end_with?("__to")
          value.end_of_day
        else
          value.beginning_of_day
        end
      end

      private

      def default_value
        options.fetch(:default_value, DEFAULT_VALUE)
      end
    end
  end
end
