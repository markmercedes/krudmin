module Krudmin
  module Presenters
    class NumberFieldPresenter < BaseFieldPresenter
      def render_list
        to_s
      end
    end
  end
end
