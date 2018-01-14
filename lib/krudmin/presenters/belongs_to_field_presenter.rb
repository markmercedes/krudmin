module Krudmin
  module Presenters
    class BelongsToFieldPresenter < BaseFieldPresenter
      delegate :associated_options, :collection_label_field, :association_name, to: :field

      def render_form
        form = options.fetch(:form)

        form.association association_name, collection: associated_options, label_method: collection_label_field, value_method: :id, input_html: {class: 'form-control select2', include_blank: true}
      end

      def render_search
        form = options.fetch(:form)
        search_form = options.fetch(:search_form)
        field_value = search_form.send(attribute)
        _associated_options = associated_options
        _attribute = attribute

        select_options = view_context.options_from_collection_for_select(_associated_options, :id, collection_label_field, field_value)

        Arbre::Context.new do
          ul(class: "list-unstyled col-sm-12") do
            li form.hidden_field("#{_attribute}_options", required: false, class: "form-control", value: :eq)
            li form.select(_attribute, select_options, {include_blank: true}, {class: "form-control select2"})
          end
        end
      end
    end
  end
end
