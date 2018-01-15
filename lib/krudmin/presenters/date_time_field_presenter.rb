module Krudmin
  module Presenters
    class DateTimeFieldPresenter < BaseFieldPresenter
      def render_search
        form = options.fetch(:form)
        _attribute = attribute

        Arbre::Context.new do
          [:from, :to].each do |range_part|
            div(class: "col-sm-6") do
              ul(class: "list-unstyled") do
                li form.hidden_field "#{_attribute}__#{range_part}_options", value: :gteq
                li form.date_field "#{_attribute}__#{range_part}", required: false, class: "form-control"
              end
            end
          end
        end
      end
    end
  end
end
