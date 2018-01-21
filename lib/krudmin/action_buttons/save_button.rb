module Krudmin
  module ActionButtons
    class SaveButton < Base
      def form_id
        @form_id ||= html_options.fetch(:form_id)
      end

      def render_form
        render_partial(:form, form_id: form_id)
      end
    end
  end
end
