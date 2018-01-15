require_relative 'number'
require_relative '../presenters/decimal_field_presenter'

module Krudmin
  module Fields
    class Decimal < Number
      PRESENTER = Krudmin::Presenters::DecimalFieldPresenter

      def delimiter
        options.fetch(:delimiter, ",")
      end

      def separator
        options.fetch(:separator, ".")
      end

      def decimals
        options.fetch(:decimals, 2)
      end
    end

  end
end
