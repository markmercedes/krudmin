module Krudmin
  module ApplicationHelper
    def body_classes
      [
        cookies["brand-minimized"] == "true" ? "brand-minimized" : nil,
        cookies["sidebar-minimized"] == "true" ? "sidebar-minimized" : nil,
      ].compact.join(" ")
    end
  end
end
