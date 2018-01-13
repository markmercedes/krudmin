module Krudmin
  module Presenters
    class NumberFieldPresenter < BaseFieldPresenter
      def render_list
        h.number_with_delimiter(to_s)
      end
    end
  end
end
