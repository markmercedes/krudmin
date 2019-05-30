module Krudmin
  module ActionButtons
    class DestroyButton < ModelActionButton
      def tooltip_title
        I18n.t("krudmin.tooltip.destroy", label: model_label)
      end
    end
  end
end
