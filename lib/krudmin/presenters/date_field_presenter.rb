module Krudmin
  module Presenters
    class DateFieldPresenter < BaseFieldPresenter
      PRESENTER = Krudmin::Presenters::DateFieldPresenter
      INPUT_FORMAT = "krudmin.date.input_format".freeze
      PICKER_CONTROL_CSS_CLASS = :datepicker

      def value_with_input_format
        if field.data
          I18n.localize(
            field.data,
            format: I18n.t(self.class::INPUT_FORMAT),
            default: field.data,
          )
        end
      end

      def render_form
        _input_options = input_options.dup
        input_class = _input_options.fetch(:class, "")
        _input_options[:class] = "#{input_class} #{self.class::PICKER_CONTROL_CSS_CLASS}"

        render_partial(partial_form, formatted_date_value: value_with_input_format, input_options: _input_options)
      end

      def render_search
        search_options = [
          {
            options: "#{attribute}__from_options",
            field: "#{attribute}__from",
            filter: :gteq,
          },
          {
            options: "#{attribute}__to_options",
            field: "#{attribute}__to",
            filter: :lteq,
          },
        ]

        render_partial(:search, search_form: search_form, search_options: search_options)
      end
    end
  end
end
