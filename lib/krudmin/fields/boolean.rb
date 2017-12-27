module Krudmin
  module Fields
    class Boolean < Base
      include Krudmin::ActivableLabeler

      SEARCH_PREDICATES = [:true, :false]
      HTML_CLASS = 'text-center'

      def to_s
        value ? label_for_active(I18n.t("krudmin.labels.yes")) : label_for_inactive(I18n.t('krudmin.labels.no'))
      end

      def render_search(page, h, options)
        form = options.fetch(:form)
        search_form = options.fetch(:search_form)
        options_value = search_form.send("#{attribute}_options")
        _attribute = attribute
        _h = h

        select_options = _h.options_for_select(search_form.search_predicates_for(_attribute), options_value)
        options_attribute = "#{_attribute}_options"

        Arbre::Context.new do
          ul(class: "list-unstyled col-sm-12") do
            li form.hidden_field(_attribute, required: false, class: "form-control", value: true)
            li form.select(options_attribute, select_options, {include_blank: true}, {class: "form-control"})
          end
        end
      end
    end
  end
end
