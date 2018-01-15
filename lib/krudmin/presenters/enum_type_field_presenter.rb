module Krudmin
  module Presenters
    class EnumTypeFieldPresenter < BelongsToFieldPresenter
      delegate :associated_options, :enum_value, to: :field

      def render_form
        if options.fetch(:input, {})[:label] == false
          form.select(attribute, view_context.options_for_select(associated_options, enum_value), {}, class: "form-control select2")
        else
          form.input attribute, collection: associated_options, selected: value, input_html: {class: "form-control select2"}
        end
      end

      private

      def dropdown_for_search
        form.select(attribute, associated_options, {include_blank: true}, {class: "form-control select2"})
      end
    end
  end
end
