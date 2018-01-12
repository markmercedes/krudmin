module Krudmin
  module Fields
    class Base
      HTML_CLASS = ''
      HTML_FORMAT = ''
      HTML_ATTRS = {}

      attr_accessor :attribute, :model, :resource, :options, :model
      def initialize(attribute, model = nil, options = {})
        @attribute = attribute
        @model = model
        options = options.dup
        @resource = options.delete(:resource)
        @options = options
      end

      def data
        @data ||= model and model.send(attribute)
      end

      def value
        data
      end

      def self.is?(klass)
        klass == self
      end

      def html_class
        self.class::HTML_CLASS
      end

      def html_format
        self.class::HTML_FORMAT
      end

      def html_attrs
        self.class::HTML_ATTRS
      end

      def self.html_class
        self::HTML_CLASS
      end

      def self.html_format
        self::HTML_FORMAT
      end

      def self.html_attrs
        self::HTML_ATTRS
      end

      def renderer
        @renderer ||= if options[:render_with]
                        options[:render_with].new(self)
                      else
                        self
                      end
      end

      def render(page, h = nil, options = {})
        if respond_to?("render_#{page}")
          renderer.send("render_#{page}", page, h, options)
        else
          to_s
        end
      end

      def render_form(page, h, options)
        options.fetch(:form).input(attribute, options.fetch(:input, {}))
      end

      def render_search(page, h, options)
        form = options.fetch(:form)
        search_form = options.fetch(:search_form)
        _attribute = attribute
        _h = h

        Arbre::Context.new do
          div(class: "col-sm-5") do
            ul(class: "list-unstyled") do
              li form.select "#{_attribute}_options", h.options_for_select(search_form.search_predicates_for(_attribute), search_form.send("#{_attribute}_options")), {}, {class: "form-control"}
            end
          end

          div(class: "col-sm-7") do
            ul(class: "list-unstyled") do
              li form.text_field(_attribute, class: "form-control", required: false)
            end
          end
        end
      end

      def to_s
        value
      end

      def field_type
        self.class.field_type
      end

      def self.field_type
        to_s.split("::").last.underscore
      end

      def self.editable_attribute(attribute)
        attribute
      end
    end
  end
end
