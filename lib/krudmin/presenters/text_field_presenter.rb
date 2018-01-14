module Krudmin
  module Presenters
    class TextFieldPresenter < BaseFieldPresenter
      def render_form
        form = options.fetch(:form)

        form.input attribute, as: :text, input_html: field.options.fetch(:input, {})
      end
    end
  end
end
