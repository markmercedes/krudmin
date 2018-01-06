module Krudmin
  module ResourceManagers
    class Base
      include Enumerable

      delegate :each, :total_pages, :current_page, :limit_value, to: :items

      MODEL_CLASSNAME = nil
      LISTABLE_ATTRIBUTES = []
      EDITABLE_ATTRIBUTES = []
      SEARCHABLE_ATTRIBUTES = []
      LISTABLE_ACTIONS = [:show, :edit, :destroy]
      ORDER_BY = []
      LISTABLE_INCLUDES = []
      RESOURCE_INSTANCE_LABEL_ATTRIBUTE = nil
      RESOURCE_LABEL = ""
      RESOURCES_LABEL = ""
      ATTRIBUTE_TYPES = {}
      PRESENTATION_METADATA = {}

      def default_attribute_type
        Krudmin::Fields::String
      end

      def map_has_many_associated_fields!(hash, key, value)
        field_type = extract_field_type(value)

        if Krudmin::Fields::HasMany.is?(field_type)
          hash["#{key}__types"] = field_type.new(key, nil).associated_resource_manager_class::ATTRIBUTE_TYPES
        end
      end

      def attribute_types
        @attribute_types ||= self.class::ATTRIBUTE_TYPES.inject({}) do |hash, item|
          key = item.first
          value = item.last

          hash[key] = value

          map_has_many_associated_fields!(hash, key, value)

          hash
        end
      end

      def html_class_for(field, model = nil, root: nil)
        field_type_for(field, model, root: root).html_class
      end

      def field_type_for(field, model = nil, root: nil)
        if root
          extract_field_type(attribute_types["#{root}__types"][field])
        else
          extract_field_type(attribute_types[field])
        end
      end

      def field_options_for(field, root: nil)
        if root
          extract_field_options(attribute_types["#{root}__types"][field])
        else
          extract_field_options(attribute_types[field])
        end
      end

      def field_for(field, model = nil, root: nil)
        field_type_for(field, model, root: root).new(field, model, field_options_for(field, root: root))
      end

      def self.constantized_methods(*attrs)
        attrs.flatten.each do |attr|
          define_method(attr) do
            self.class.const_get(attr.upcase)
          end
        end
      end

      def model_label(given_model)
        given_model.send(resource_instance_label_attribute)
      end

      constantized_methods :searchable_attributes, :resource_label, :resources_label, :model_classname, :listable_attributes, :editable_attributes, :listable_actions, :order_by, :listable_includes, :resource_instance_label_attribute

      def raw_editable_attributes
        self.class::EDITABLE_ATTRIBUTES
      end

      def editable_attributes
        @editable_attributes ||= if raw_editable_attributes.is_a?(Hash)
          raw_editable_attributes.values.flatten
        else
          raw_editable_attributes
        end
      end

      def presentation_metadata
        self.class::PRESENTATION_METADATA
      end

      def grouped_attributes
        @grouped_attributes ||= if raw_editable_attributes.is_a?(Hash)
          raw_editable_attributes.inject({}) do |hash, value|
            key = value.first
            attributes = value.last
            hash[key] = {attributes: attributes}.merge(presentation_metadata.fetch(key))
            hash
          end
        else
          {general: {attributes: raw_editable_attributes, label: "General"}}
        end
      end

      def self.editable_attributes
        new.editable_attributes
      end

      def permitted_attributes
        editable_attributes.map do |attribute|
          extract_field_type(attribute_types[attribute]).editable_attribute(attribute)
        end
      end

      def label_for(given_model)
        given_model.send(resource_instance_label_attribute)
      end

      def items
        @items ||= list_scope
      end

      def scope
        model_class.all
      end

      def list_scope
        scope.includes(listable_includes).order(order_by)
      end

      def model_class
        @model_class ||= model_classname.constantize
      end

      def self.model_class
        self::MODEL_CLASSNAME.constantize
      end

      private

      def extract_field_type(field_metadata)
        if field_metadata.is_a?(Hash)
          field_metadata.fetch(:type)
        else
          field_metadata
        end || default_attribute_type
      end

      def extract_field_options(field_metadata)
        if field_metadata.is_a?(Hash)
          field_metadata.except(:type)
        else
          {}
        end
      end
    end
  end
end
