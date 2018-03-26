module Krudmin
  module ApplicationHelper
    PERSISTED_CSS_BODY_CLASSES = ["sidebar-minimized", "brand-minimized", "sidebar-hidden"].freeze

    def body_classes
      PERSISTED_CSS_BODY_CLASSES.map { |body_class| evaluate_boolean_string(body_class) }.compact.join(" ")
    end

    private

    def evaluate_boolean_string(value)
      cookies[value] == "true" ? value : nil
    end
  end
end
