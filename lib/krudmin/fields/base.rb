module Krudmin
  module Fields
    class Base
      HTML_CLASS = ''
      HTML_FORMAT = ''
      HTML_ATTRS = {}

      attr_accessor :attribute, :data, :resource, :options
      def initialize(attribute, data, options = {})
        @attribute = attribute
        @data = data
        options = options.dup
        @resource = options.delete(:resource)
        @options = options
      end

      def value
        data
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

      def render(page, h = nil, options = {})
        # binding.pry if attribute == :active
        if respond_to?("render_#{page}")
          send("render_#{page}", page, h, options)
        else
          # attribute
          to_s
        end
      end

      def render_form(page, h, options)
        options.fetch(:form).input(attribute)
      end

      def render_search(page, h, options)
        # = f.text_field field, required: false, class: "form-control"
        options.fetch(:form).text_field(attribute, class: "form-control", required: false)
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
    end
  end
end
