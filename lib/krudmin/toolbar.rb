module Krudmin
  class Toolbar
    attr_reader :page, :view_context

    TOOLBAR_SEPARATOR = "&nbsp;&nbsp;&nbsp;".html_safe

    def initialize(page, view_context)
      @page = page
      @view_context = view_context
    end

    def self.configure(page, view_context, &block)
      new(page, view_context).setup_with(&block)
    end

    def setup_with(&block)
      yield(self)
    end

    def button(button_type, *args, &block)
      toolbar_block { action_button(button_type, *args, &block) }
    end

    def link(path, *args, &block)
      toolbar_block { action_button("link", path, *args, &block) }
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

    def action_button(button_type,*args, &block)
      "Krudmin::ActionButtons::#{button_type.to_s.classify}Button".constantize.new(page, view_context, *args, &block)
    end
  end
end
