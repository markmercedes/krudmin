module Krudmin
  module ActivableLabeler
    def label_for_active(value)
      Arbre::Context.new { span(class: "badge badge-success") { value } }
    end

    def label_for_inactive(value)
      Arbre::Context.new { span(class: "badge badge-danger") { value } }
    end
  end
end
