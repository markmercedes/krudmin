module Krudmin
  module Presenters
    class BooleanFieldPresenter < BaseFieldPresenter
      def render_search
        form = options.fetch(:form)
        search_form = options.fetch(:search_form)
        options_value = search_form.send("#{attribute}_options")
        _attribute = attribute
        _view_context = view_context

        select_options = _view_context.options_for_select(search_form.search_predicates_for(_attribute), options_value)
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
