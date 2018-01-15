module Krudmin
  module Presenters
    class BelongsToFieldPresenter < BaseFieldPresenter
      delegate :associated_options, :collection_label_field, :association_name, to: :field

      def render_form
        form = options.fetch(:form)

        form.association association_name, collection: associated_options, label_method: collection_label_field, value_method: :id, input_html: {class: 'form-control select2', include_blank: true}
      end

      def render_search
        _form = form
        _attribute = attribute
        _dropdown = dropdown_for_search

        Arbre::Context.new do
          ul(class: "list-unstyled col-sm-12") do
            li _form.hidden_field("#{_attribute}_options", required: false, class: "form-control", value: :eq)
            li _dropdown
          end
        end
      end

      private

      def dropdown_for_search
        field_value = search_form.send(attribute)

        select_options = view_context.options_from_collection_for_select(associated_options, :id, collection_label_field, field_value)

        form.select(attribute, select_options, {include_blank: true}, {class: "form-control select2"})
      end
    end
  end
end
