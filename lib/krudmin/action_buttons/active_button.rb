module Krudmin
  module ActionButtons
    class ActiveButton < ModelActionButton
      def tooltip_title
        model.active? ? I18n.t("krudmin.tooltip.deactivate", label: model_label) : I18n.t("krudmin.tooltip.activate", label: model_label)
      end
    end
  end
end
