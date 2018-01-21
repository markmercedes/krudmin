module Krudmin
  module ToolbarSupport

    extend ActiveSupport::Concern

    included do
      helper_method :configure_toolbar
    end

    class ToolbarConfig
      attr_reader :h
      def initialize(h)
        @h = h
      end

      def self.configure(h, &block)
        new(h).setup_with(&block)
      end

      def setup_with(&block)
        yield(self)
      end

      def button(button_type, *args)
        toolbar_block { send("#{button_type}", *args) }
      end

      def separator
        h.content_for(:toolbar, "&nbsp;&nbsp;&nbsp;".html_safe)
      end

      def toolbar_block(&block)
        h.content_for(:toolbar) do
          block.call.to_s
        end

        separator
      end

      def action_button(button_type, page, path, *args)
        "Krudmin::ActionButtons::#{button_type.to_s.classify}Button".constantize.new(page, h, path, *args)
      end

      def method_missing(method, *args, &block)
        action_button(method, *args)
      end
    end

    def configure_toolbar(h, &block)
      ToolbarConfig.configure(h, &block)
    end
  end
end
