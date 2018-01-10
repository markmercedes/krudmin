module Krudmin
  module Fields
    class EnumType < Associated

      def selected
        value
      end

      def enum_value
        @enum_value ||= model and model.send("#{attribute}_before_type_cast")
      end

      def collection_label_field
        @collection_label_field ||= options.fetch(:collection_label_field, :label)
      end

      def associated_options
        @associated_options ||= association_predicate.call(associated_class)
      end

      def associated_options
        options.fetch(:associated_options).call
      end

      def render_form(page, h, options)
        form = options.fetch(:form)

        form.input attribute, collection: associated_options, selected: value, input_html: {class: "form-control select2"}
      end
    end
  end
end
