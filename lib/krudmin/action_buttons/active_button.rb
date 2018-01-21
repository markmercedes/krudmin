module Krudmin
  module ActionButtons
    class ActiveButton < ModelActionButton
      def render_list
        render_partial(:list)
      end
    end
  end
end
