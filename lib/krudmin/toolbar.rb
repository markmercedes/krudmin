module Krudmin
  class Toolbar
    attr_reader :view_context

    TOOLBAR_SEPARATOR = "&nbsp;&nbsp;&nbsp;".html_safe

    def initialize(view_context)
      @view_context = view_context
    end

    def self.configure(view_context, &block)
      new(view_context).setup_with(&block)
    end

    def setup_with(&block)
      yield(self)
    end

    def button(button_type, *args)
      toolbar_block { action_button(button_type, *args) }
    end

    def separator
      view_context.content_for(:toolbar, TOOLBAR_SEPARATOR)
    end

    def toolbar_block(&block)
      view_context.content_for(:toolbar) do
        block.call.to_s
      end

      separator
    end

    def action_button(button_type, page, *args)
      "Krudmin::ActionButtons::#{button_type.to_s.classify}Button".constantize.new(page, view_context, *args)
    end
  end
end
