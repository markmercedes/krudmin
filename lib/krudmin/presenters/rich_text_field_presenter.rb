module Krudmin
  module Presenters
    class RichTextFieldPresenter < BaseFieldPresenter
      def render_form
        render_partial(:form)
      end

      def render_list
        value.html_safe if value
      end

      alias_method :render_show, :render_list
    end
  end
end
