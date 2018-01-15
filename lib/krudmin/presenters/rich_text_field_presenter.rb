module Krudmin
  module Presenters
    class RichTextFieldPresenter < BaseFieldPresenter
      def render_form
        form.trix_editor attribute, field.options.fetch(:input, {})
      end

      def render_list
        value and value.html_safe
      end

      alias_method :render_show, :render_list
    end
  end
end
