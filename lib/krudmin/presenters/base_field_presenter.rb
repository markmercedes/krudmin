module Krudmin
  module Presenters
    class BaseFieldPresenter
      VIEW_PATH = :application

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

      def render
        respond_to?("render_#{page}") ? send("render_#{page}") : to_s
      end

      def render_form
        render_partial(:form, input_options: input_options)
      end

      def render_search
        render_partial(:search, search_form: search_form, options_attribute: options_attribute)
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
        view_context.render(partial: "krudmin/#{self.class::VIEW_PATH}/fields/#{partial_path}/#{partial_name}", locals: default_locals.merge(locals))
      end

      def partial_path
        @partial_path ||= self.class.name.demodulize.split('Field').first.underscore
      end

      def default_locals
        {field: self, form: form, input_options: input_options, attribute: attribute}
      end

      def form
        @form ||= options.fetch(:form)
      end

      def search_form
        @search_form ||= options[:search_form]
      end
    end
  end
end
