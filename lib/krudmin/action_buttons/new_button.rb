module Krudmin
  module ActionButtons
    class NewButton < Base
      def render_list
        render_partial(:list)
      end
    end
  end
end
