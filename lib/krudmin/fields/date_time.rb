require_relative "../presenters/date_time_field_presenter"

module Krudmin
  module Fields
    class DateTime < Base
      SEARCH_PREDICATES = [:eq, :not_eq, :lt, :lteq, :gt, :gteq]
      DEFAULT_VALUE = "-"
      PRESENTER = Krudmin::Presenters::DateTimeFieldPresenter

      def date
        if data
          I18n.localize(
            data.in_time_zone(timezone).to_date,
            format: format,
          )
        end
      end

      def datetime
        if data
          I18n.localize(
            data.in_time_zone(timezone),
            format: format,
            default: data,
          )
        end
      end

      def to_s
        case value
        when ::DateTime
          datetime
        when ::Date
          date
        else
          datetime
        end || default_value
      end

      def format
        options.fetch(:format, :default)
      end

      def timezone
        options.fetch(:timezone, "UTC")
      end

      def self.search_config_for(field)
        ["#{field}__from".to_sym, "#{field}__to".to_sym]
      end

      def self.search_criteria_for(key, raw_value)
        value = Date.parse(raw_value)

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
