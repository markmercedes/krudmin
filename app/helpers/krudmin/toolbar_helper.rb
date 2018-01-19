module Krudmin
  module ToolbarHelper
    TOOLBAR_SEPARATOR = "&nbsp;&nbsp;&nbsp;".html_safe

    def toolbar_separator(h)
      h.content_for(:toolbar, TOOLBAR_SEPARATOR)
    end

    def toolbar_block(h, &block)
      h.content_for(:toolbar) do
        block.call
      end

      toolbar_separator(h)
    end
  end
end
