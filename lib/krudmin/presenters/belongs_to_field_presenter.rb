module Krudmin
  module Presenters
    class BelongsToFieldPresenter < BaseFieldPresenter
      delegate :associated_options, :collection_label_field, :association_name, :association_path, :link_to_path, :humanized_value, to: :field

      alias linkable? association_path

      def render_form
        render_partial(:form, association_name: association_name, associated_options: associated_options, collection_label_field: collection_label_field)
      end

      def render_search
        render_partial(:search, search_form: search_form,
                                association_name: association_name,
                                associated_options: associated_options,
                                collection_label_field: collection_label_field,
                                search_value: search_value,
                                options_attribute: options_attribute)
      end

      def render_show
        render_partial(:show, humanized_value: humanized_value,
                              linkable: linkable?,
                              link_to_association: ->(view_context) { link_to_path(view_context) })
      end
    end
  end
end
