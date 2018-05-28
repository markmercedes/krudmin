require_relative "../constants_to_methods_exposer"
require_relative "../presenters/base_field_presenter"

module Krudmin
  module Fields
    class Base
      extend Krudmin::ConstantsToMethodsExposer
      include Krudmin::Presenters::BaseFieldPresenter::Renderer

      HTML_CLASS = ""
      HTML_FORMAT = ""
      HTML_ATTRS = {}
      PRESENTER = Krudmin::Presenters::BaseFieldPresenter

      constantized_methods :html_class, :html_format, :html_attrs

      attr_reader :attribute, :model, :resource, :options, :presenter, :presenter_contexts
      def initialize(attribute, model = nil, options = {})
        @attribute = attribute
        @model = model
        @options = options.dup
        @resource = @options.delete(:resource)
        @presenter = @options.fetch(:present_with, self.class::PRESENTER)
        @presenter_contexts = {}
      end

      def parse(value)
        value
      end

      def data
        @data ||= model&.send(attribute)
      end

      def value
        data
      end

      def self.is?(klass)
        klass == self
      end

      def to_s
        value
      end

      def field_type
        self.class.field_type
      end

      def editable_attribute
        attribute
      end

      def permitted_attribute
        attribute
      end

      def self.field_type
        to_s.split("::").last.underscore
      end

      def self.search_config_for(field)
        field
      end

      def self.search_criteria_for(_, value)
        value
      end

      def self.editable_attribute(attribute)
        new(attribute).editable_attribute
      end

      def self.permitted_attribute(attribute)
        new(attribute).permitted_attribute
      end

      def self.type_as_hash(attribute, options)
        { attribute => options }
      end
    end
  end
end
