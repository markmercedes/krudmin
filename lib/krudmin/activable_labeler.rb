module Krudmin
  module ActivableLabeler
    include ActionView::Helpers::TagHelper
    include ActionView::Context

    def label_for_active(value)
      content_tag(:span, class: "badge badge-success") { value }
    end

    def label_for_inactive(value)
      content_tag(:span, class: "badge badge-danger") { value }
    end
  end
end
