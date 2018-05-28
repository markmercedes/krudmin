require_relative "../presenters/date_time_field_presenter"

module Krudmin
  module Fields
    class DateTime < Date
      PRESENTER = Krudmin::Presenters::DateTimeFieldPresenter

      def parse(value)
        return value if date_unparsable?(value)

        (Time.zone ? Time.zone : Time).strptime(value, input_format)
      end

      def value
        if data
          I18n.localize(
            data,
            format: format,
            default: data,
          )
        end
      end
    end
  end
end
