module Krudmin
  module Presenters
    class BelongsToOneFieldPresenter < BaseFieldPresenter
      def render_form
        render_partial(partial_form, options: options, form_fields: form_fields)
      end

      def fields_partial
        field.options.fetch(:fields_partial, :form_fields)
      end

      private

      def form_fields
        render_partial_to_string(fields_partial, options: options)
      end
    end
  end
end
