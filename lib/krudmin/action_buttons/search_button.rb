module Krudmin
  module ActionButtons
    class SearchButton < Base
      def render_list
        render_partial(:list)
      end
    end
  end
end
