module Krudmin
  module Fields
    class Boolean < Base
      include Krudmin::ActivableLabeler

      HTML_CLASS = 'text-center'

      def to_s
        value ? label_for_active(I18n.t("krudmin.labels.yes")) : label_for_inactive(I18n.t('krudmin.labels.no'))
      end
    end
  end
end
