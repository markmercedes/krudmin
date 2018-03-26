module Krudmin
  module ApplicationHelper
    def body_classes
      [
        cookies["sidebar-minimized"] == "true" ? "sidebar-minimized" : nil,
        cookies["brand-minimized"] == "true" ? "brand-minimized" : nil,
        cookies["sidebar-hidden"] == "true" ? "sidebar-hidden" : nil,
      ].compact.join(" ")
    end
  end
end
