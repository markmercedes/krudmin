module Krudmin
  module Presenters
    class BelongsToFieldPresenter < BaseFieldPresenter
      delegate :associated_options, :collection_label_field, :association_name, :association_path, :link_to_path, :humanized_value, :group_method, :group_label_method, to: :field
      delegate :input_type, :associated_resource_manager_class, :edit_path, :add_path, to: :field

      alias linkable? association_path

      def associated_model
        associated_resource_manager_class::MODEL_CLASSNAME.constantize.new
      end

      def associated_resource_label
        associated_resource_manager_class::RESOURCE_LABEL
      end

      def render_json
        super.merge(
          options: standarized_associated_options,
          collection_label_field: field.collection_label_field
        )
      end

      def render_form
        render_partial(:form, association_name: association_name,
                              associated_options: associated_options,
                              collection_label_field: collection_label_field,
                              group_method: group_method,
                              group_label_method: group_label_method,
                              input_type: input_type,
                              associated_model: associated_model,
                              add_path: add_path,
                              edit_path: edit_path,
                              associated_resource_label: associated_resource_label,
                              associated_resource_manager_class: associated_resource_manager_class)
      end

      def render_search
        render_partial(:search, search_form: search_form,
                                association_name: association_name,
                                associated_options: associated_options,
                                collection_label_field: collection_label_field,
                                search_value: search_value,
                                options_attribute: options_attribute,
                                group_method: group_method,
                                group_label_method: group_label_method,
                                input_type: input_type,
                                associated_resource_manager_class: associated_resource_manager_class)
      end

      def render_show
        render_partial(:show, humanized_value: humanized_value,
                              linkable: linkable?,
                              link_to_association: ->(view_context) { link_to_path(view_context) })
      end

      def standarized_associated_options
        associated_options.as_json(only: [field.primary_key, field.collection_label_field])
      end
    end
  end
end
