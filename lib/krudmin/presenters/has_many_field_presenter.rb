module Krudmin
  module Presenters
    class HasManyFieldPresenter < BaseFieldPresenter
      def render_form
        render_partial(partial_form, options: options, render_partial: method(:render_partial), form_fields_partial: form_fields_partial)
      end

      def partial_form
        field.options.fetch(:partial_form, :form)
      end

      def child_partial_form
        field.options.fetch(:child_partial_form, :form_fields)
      end

      def form_fields_partial
        "#{partial_path}/#{child_partial_form}"
      end

      def render_list
        render_partial(partial_display, options: options, field: field, render_partial: method(:render_partial))
      end

      def partial_display
        field.options.fetch(:partial_display, :show)
      end

      def child_partial_display
        field.options.fetch(:child_partial_display, :show_fields)
      end
    end
  end
end
