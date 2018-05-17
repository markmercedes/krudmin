module Krudmin
  module ActivableLabeler
    if defined?(Rails)
      include ActionView::Helpers::TagHelper
      include ActionView::Context
    end

    def label_for_active(value)
      content_tag(:span, class: "badge badge-success") { value }
    end

    def label_for_inactive(value)
      content_tag(:span, class: "badge badge-danger") { value }
    end
  end
end
