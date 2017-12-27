module Krudmin
  module Fields
    class DateTime < Base
      def date
        I18n.localize(
          data.in_time_zone(timezone).to_date,
          format: format,
        )
      end

      def datetime
        I18n.localize(
          data.in_time_zone(timezone),
          format: format,
          default: data,
        )
      end

      def to_s
        case value
        when Date
          date
        else
          datetime
        end
      end

      private

      def format
        options.fetch(:format, :default)
      end

      def timezone
        options.fetch(:timezone, "UTC")
      end
    end
  end
end
