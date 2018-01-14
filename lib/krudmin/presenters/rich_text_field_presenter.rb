module Krudmin
  module Presenters
    class RichTextFieldPresenter < BaseFieldPresenter
      def render_form
        form = options.fetch(:form)

        form.trix_editor attribute, field.options.fetch(:input, {})
      end

      def render_list
        value.html_safe
      end

      def render_show
        value.html_safe
      end
    end
  end
end
