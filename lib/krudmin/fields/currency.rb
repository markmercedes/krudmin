require_relative 'number'
require_relative '../presenters/currency_field_presenter'

module Krudmin
  module Fields
    class Currency < Number
      PRESENTER = Krudmin::Presenters::CurrencyFieldPresenter

      def value
        super.round(decimals)
      end

      def prefix
        options.fetch(:prefix, "$")
      end

      def decimals
        options.fetch(:decimals, 2)
      end
    end
  end
end
