require_relative "../presenters/date_field_presenter"

module Krudmin
  module Fields
    class Date < Base
      SEARCH_PREDICATES = [:eq, :not_eq, :lt, :lteq, :gt, :gteq]
      DEFAULT_VALUE = "-".freeze
      PRESENTER = Krudmin::Presenters::DateFieldPresenter

      def date_unparsable?(value)
        value.blank? || value.respond_to?(:strftime)
      end

      def parse(value)
        return value if date_unparsable?(value)

        ::Date.strptime(value, input_format)
      end

      def input_format
        options.fetch(:input_format, I18n.t(self.class::PRESENTER::INPUT_FORMAT))
      end

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
        value = ::Date.strptime(raw_value, I18n.t(PRESENTER::INPUT_FORMAT))

        key.to_s.end_with?("__to") ? value.end_of_day : value.beginning_of_day
      end

      private

      def default_value
        options.fetch(:default_value, DEFAULT_VALUE)
      end
    end
  end
end
