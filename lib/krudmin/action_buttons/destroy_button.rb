module Krudmin
  module ActionButtons
    class DestroyButton < ModelActionButton
      def render_list
        render_partial(:list)
      end
    end
  end
end
