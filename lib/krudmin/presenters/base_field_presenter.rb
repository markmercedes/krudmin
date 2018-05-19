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

      delegate :attribute, :value, :to_s, to: :field

      attr_reader :field, :page, :view_context, :options
      def initialize(field, page, view_context = nil, options = {})
        @field = field
        @page = page
        @view_context = view_context
        @options = options
      end

      def input_options
        field.options.fetch(:input, {}).merge(options.fetch(:input, {}))
      end

      def json_options
        field.options.fetch(:json, {}).merge(options.fetch(:json, {}))
      end

      def render
        respond_to?("render_#{page}") ? send("render_#{page}") : to_s
      end

      def render_json
        {
          class: field.class.name,
          attribute: field.attribute,
          value: field.value,
        }
      end

      def render_form
        render_partial(partial_form, input_options: input_options)
      end

      DEFAULT_PARTIAL_FORM = :form_field
      def partial_form
        field.options.fetch(:partial_form, DEFAULT_PARTIAL_FORM)
      end

      def render_search
        render_partial(:search, search_form: search_form, options_attribute: options_attribute)
      end

      def model_class
        if field.model
          field.model.class
        elsif search_form
          search_form.model_class
        end
      end

      def field_label
        input_options.fetch(:label, model_class.human_attribute_name(attribute))
      end

      private

      def options_attribute
        "#{attribute}_options"
      end

      def search_value
        search_form.send(attribute)
      end

      def options_value
        search_form.send(options_attribute)
      end

      def render_partial(partial_name, locals = {})
        view_context.controller.lookup_context.prefixes.prepend partial_path

        view_context.render(partial: partial_name.to_s, locals: default_locals.merge(locals))
      end

      def render_partial_to_string(partial_name, locals = {})
        view_context.controller.lookup_context.prefixes.prepend partial_path

        view_context.controller.render_to_string(partial: partial_name.to_s, locals: default_locals.merge(locals))
      end

      def partial_path
        "#{Krudmin::Config.theme}/fields/#{partial_scope}/"
      end

      def partial_scope
        @partial_scope ||= field.class.name.demodulize.underscore
      end

      def default_locals
        { field: field, form: form, input_options: input_options, attribute: attribute, options: options, field_label: field_label }
      end

      def form
        @form ||= options[:form]
      end

      def search_form
        @search_form ||= options[:search_form]
      end
    end
  end
end
