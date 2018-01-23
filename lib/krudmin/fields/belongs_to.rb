require_relative "../presenters/belongs_to_field_presenter"

module Krudmin
  module Fields
    class BelongsTo < Associated
      PRESENTER = Krudmin::Presenters::BelongsToFieldPresenter

      def selected
        value
      end

      def selected_association
        model.send(association_name)
      end

      def humanized_value
        selected_association.send(collection_label_field)
      end

      def collection_label_field
        @collection_label_field ||= options.fetch(:collection_label_field, :label)
      end

      def associated_options
        @associated_options ||= association_predicate.call(associated_class)
      end

      def link_to_path(view_context)
        view_context.send(association_path, selected_association)
      end

      def association_path
        options[:association_path]
      end
    end
  end
end
