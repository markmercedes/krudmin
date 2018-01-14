module Krudmin
  module Presenters
    class EnumTypeFieldPresenter < BaseFieldPresenter
      delegate :associated_options, :enum_value, to: :field

      def render_search
        form = options.fetch(:form)
        search_form = options.fetch(:search_form)
        _associated_options = associated_options
        _attribute = attribute

        Arbre::Context.new do
          ul(class: "list-unstyled col-sm-12") do
            li form.hidden_field("#{_attribute}_options", required: false, class: "form-control", value: :eq)
            li form.select(_attribute, _associated_options, {include_blank: true}, {class: "form-control select2"})
          end
        end
      end

      def render_form
        form = options.fetch(:form)

        if options.fetch(:input, {})[:label] == false
          form.select(attribute, view_context.options_for_select(associated_options, enum_value), {}, class: "form-control select2")
        else
          form.input attribute, collection: associated_options, selected: value, input_html: {class: "form-control select2"}
        end
      end
    end
  end
end
