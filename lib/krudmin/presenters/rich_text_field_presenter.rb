module Krudmin
  module Presenters
    class RichTextFieldPresenter < BaseFieldPresenter
      def render_form
        form = options.fetch(:form)

        form.trix_editor attribute, field.options.fetch(:input, {})
      end
    end
  end
end
