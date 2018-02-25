require_relative "../presenters/date_time_field_presenter"

module Krudmin
  module Fields
    class DateTime < Date
      PRESENTER = Krudmin::Presenters::DateTimeFieldPresenter

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
