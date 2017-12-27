module Krudmin
  module Fields
    class Number < Base
      HTML_CLASS = 'text-right'
      SEARCH_PREDICATES = [:eq, :not_eq, :lt, :lteq, :gt, :gteq]

      def to_s
        data.nil? ? "-" : format_string % value
      end

      def value
        (data * options.fetch(:multiplier, 1)).round(decimals)
      end

      def render_list(page, h, options)
        h.number_with_delimiter(value)
      end

      private

      def format_string
        prefix + "%.#{decimals}f" + suffix
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
    end
  end
end
