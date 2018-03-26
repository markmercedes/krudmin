module Krudmin
  module ActionButtons
    class CancelButton < Base
      def initialize(page, view_context, action_path = nil, html_options = {}, &block)
        super

        @action_path ||= view_context.resource_root
        @page = :base
      end

      def render_base
        render_partial(:base)
      end
    end
  end
end
