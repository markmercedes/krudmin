module Krudmin
  module ActionButtons
    class CancelButton < Base
      def initialize(page, view_context, action_path = nil, html_options = {}, &block)
        super

        @page = :base
      end

      def render_base
        render_partial(:base)
      end

      def tooltip_title
        I18n.t("krudmin.tooltip.cancel")
      end
    end
  end
end
