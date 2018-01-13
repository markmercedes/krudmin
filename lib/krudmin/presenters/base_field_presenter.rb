module Krudmin
  module Presenters
    class BaseFieldPresenter
      module Renderer
        def render(page, view_context = nil, options = {})
          presenter_contexts.fetch(page) { presenter.new(self, page, view_context, options).render }
        end

        def presenter_instance
          @presenter_instance ||= presenter.new(self, nil)
        end
      end

      def self.render(field, page, view_context = nil, options = {})
        new(field, page, view_context, options).render
      end

      delegate :attribute, :options, :value, :to_s, to: :field

      attr_reader :field, :page, :view_context, :options
      def initialize(field, page, view_context = nil, options = {})
        @field = field
        @page = page
        @view_context = view_context
        @options = options
      end

      def render
        respond_to?("render_#{page}") ? send("render_#{page}") : to_s
      end

      def render_form
        options.fetch(:form).input(attribute, options.fetch(:input, {}))
      end

      def render_search
        form = options.fetch(:form)
        search_form = options.fetch(:search_form)
        _attribute = attribute
        _view_context = view_context

        Arbre::Context.new do
          div(class: "col-sm-5") do
            ul(class: "list-unstyled") do
              li form.select "#{_attribute}_options", _view_context.options_for_select(search_form.search_predicates_for(_attribute), search_form.send("#{_attribute}_options")), {}, {class: "form-control"}
            end
          end

          div(class: "col-sm-7") do
            ul(class: "list-unstyled") do
              li form.text_field(_attribute, class: "form-control", required: false)
            end
          end
        end
      end
    end
  end
end
