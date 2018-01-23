module Krudmin
  module Presenters
    class CurrencyFieldPresenter < BaseFieldPresenter
      def render_list
        view_context.number_to_currency(value, precision: field.decimals, unit: field.prefix)
      end
    end
  end
end
