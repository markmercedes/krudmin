module Krudmin
  module Presenters
    class HasManyFieldPresenter < BaseFieldPresenter
      def render_form
        view_context.render(partial: partial_form, locals: {options: options, page: page, field: field})
      end

      def partial_form
        field.options.fetch(:partial_form, "has_many_form")
      end

      def child_partial_form
        field.options.fetch(:child_partial_form, "has_many_fields")
      end

      def render_list
        view_context.render(partial: partial_display, locals: {options: options, page: page, field: field})
      end

      def partial_display
        field.options.fetch(:partial_display, "has_many_display")
      end

      def child_partial_display
        field.options.fetch(:child_partial_display, "has_many_fields_display")
      end

    end
  end
end
