module Krudmin
  module Presenters
    class BooleanFieldPresenter < BaseFieldPresenter
      def render_search
        render_partial(:search, options_attribute: options_attribute, search_value: search_value, options_value: options_value)
      end
    end
  end
end
