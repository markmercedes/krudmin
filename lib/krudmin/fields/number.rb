require_relative "../presenters/number_field_presenter"

module Krudmin
  module Fields
    class Number < Base
      HTML_CLASS = "text-right"
      SEARCH_PREDICATES = [:eq, :not_eq, :lt, :lteq, :gt, :gteq]
      DEFAULT_VALUE = "-"
      DEFAULT_PADDING_VALUE = "0"
      PRESENTER = Krudmin::Presenters::NumberFieldPresenter

      def to_s
        data.nil? ? default_value : formatted_value
      end

      def value
        (data * options.fetch(:multiplier, 1)) if data
      end

      private

      def formatted_value
        [
          prefix,
          (format_string % value).rjust(padding, pad_with),
          suffix,
        ].join
      end

      def default_value
        options.fetch(:default_value, self.class::DEFAULT_VALUE)
      end

      def format_string
        "%.#{decimals}f"
      end

      def prefix
        options[:prefix].to_s
      end

      def suffix
        options[:suffix].to_s
      end

      def decimals
        _left, right = data.to_s.split(".")
        default = right.nil? ? 0 : right.size
        options.fetch(:decimals, default)
      end

      def pad_with
        options.fetch(:pad_with, self.class::DEFAULT_PADDING_VALUE)
      end

      def padding
        options.fetch(:padding, 0)
      end
    end
  end
end
