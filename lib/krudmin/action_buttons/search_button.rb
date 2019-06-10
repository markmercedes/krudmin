module Krudmin
  module ActionButtons
    class SearchButton < Base
      def tooltip_title
        I18n.t("krudmin.tooltip.search")
      end
    end
  end
end
