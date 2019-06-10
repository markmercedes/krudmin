module Krudmin
  module ActionButtons
    class NewButton < Base
      def initialize(page, view_context, action_path = nil, html_options = {}, &block)
        super
      end

      def tooltip_title
        I18n.t("krudmin.tooltip.add_new", label: view_context.krudmin_manager.resource_label)
      end
    end
  end
end
