module Krudmin
  module ActionButtons
    class ShowButton < ModelActionButton
      def tooltip_title
        I18n.t("krudmin.tooltip.show", label: model_label)
      end
    end
  end
end
