module Krudmin
  module Presenters
    class DecimalFieldPresenter < BaseFieldPresenter
      def render_list
        view_context.number_with_delimiter(value, {precision: field.decimals, delimiter: field.delimiter, separator: field.separator})
      end
    end
  end
end
