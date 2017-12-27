module Krudmin
  module Fields
    class BelongsTo < Associated

      def selected
        value
      end

      def collection_label_field
        @collection_label_field ||= options.fetch(:collection_label_field, :label)
      end

      def associated_options
        @associated_options ||= association_predicate.call(associated_class)
      end

      def render_form(page, h, options)
        form = options.fetch(:form)

        form.association association_name, collection: associated_options, label_method: collection_label_field, value_method: :id, input_html: {class: 'form-control select2', include_blank: true}
      end
    end
  end
end
