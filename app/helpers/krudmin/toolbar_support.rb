module Krudmin
  module ToolbarSupport

    extend ActiveSupport::Concern

    included do
      helper_method :toolbar_separator, :toolbar_block
    end

    def toolbar_separator(h)
      h.content_for(:toolbar, "&nbsp;&nbsp;&nbsp;".html_safe)
    end

    def toolbar_block(h, &block)
      h.content_for(:toolbar) do
        block.call
      end

      toolbar_separator(h)
    end
  end
end
