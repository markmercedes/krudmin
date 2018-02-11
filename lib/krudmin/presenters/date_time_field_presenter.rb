module Krudmin
  module Presenters
    class DateTimeFieldPresenter < DateFieldPresenter
      INPUT_FORMAT = "krudmin.datetime.input_format".freeze
      PICKER_CONTROL_CSS_CLASS = :datetimepicker
    end
  end
end
