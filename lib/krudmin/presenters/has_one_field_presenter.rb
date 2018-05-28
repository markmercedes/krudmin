module Krudmin
  module Presenters
    class HasOneFieldPresenter < BaseFieldPresenter
      def render_form
        render_partial(partial_form, options: options, form_fields: form_fields, display_fields_on_load: display_fields_on_load?, required: required?)
      end

      def fields_partial
        field.options.fetch(:fields_partial, :form_fields)
      end

      def required?
        field.options.fetch(:required, false)
      end

      def display_fields_on_load?
        required? || field.model.send(attribute)&.id
      end

      private

      def form_fields
        render_partial_to_string(fields_partial, options: options)
      end
    end
  end
end
