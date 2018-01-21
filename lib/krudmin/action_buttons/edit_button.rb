module Krudmin
  module ActionButtons
    class EditButton < ModelActionButton
      def render_form
        render_partial(:form)
      end

      def render_list
        render_partial(:list)
      end
    end
  end
end
