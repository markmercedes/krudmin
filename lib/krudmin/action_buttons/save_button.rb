module Krudmin
  module ActionButtons
    class SaveButton < Base
      def form_id
        @form_id ||= extract_form_id
      end

      def render_form
        render_partial(:form, form_id: form_id)
      end

      private

      def extract_form_id
        html_options[:form_id] ? html_options[:form_id] : html_options.delete(:form).options.fetch(:html).fetch(:id)
      end
    end
  end
end
