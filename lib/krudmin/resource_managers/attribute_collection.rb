module Krudmin
  module ResourceManagers
    class AttributeCollection
      attr_reader :model, :attributes_metadata, :attributes, :searchable_attributes, :presentation_metadata, :listable_attributes
      def initialize(model, attributes_metadata, attributes, listable_attributes, searchable_attributes, presentation_metadata)
        @model = model
        @attributes_metadata = attributes_metadata
        @presentation_metadata = presentation_metadata
        @listable_attributes = collection_or_default(listable_attributes)
        @searchable_attributes = collection_or_default(searchable_attributes)
        @attributes = collection_or_default(attributes)
      end

      def collection_or_default(collection)
        collection.any? ? collection : column_names
      end

      def column_names
        @column_names ||= (model.column_names - invisible_columns).map(&:to_sym)
      end

      def grouped_attributes
        @grouped_attributes ||= if attributes.is_a?(Hash)
          attributes.inject({}) do |hash, value|
            key = value.first
            attributes = value.last
            hash[key] = {attributes: attributes}.merge(presentation_metadata.fetch(key))
            hash
          end
        else
          {general: {attributes: attributes, label: "General"}}
        end
      end

      def editable_attributes
        @editable_attributes ||= attributes.is_a?(Hash) ? attributes.values.flatten : attributes
      end

      def permitted_attributes
        @permitted_attributes ||= editable_attributes.map do |attribute|
          attribute_for(attribute).type.editable_attribute(attribute)
        end
      end

      def attribute_for(field, root = nil)
        if root
          attribute_types[root].type_as_hash[:__attributes][field]
        else
          attribute_types[field]
        end || Attribute.new(field)
      end

      def attribute_types
        @attribute_types ||= attributes_metadata.inject({}) do |hash, item|
          attribute = item.first
          options = item.last

          hash[attribute] = Attribute.from(attribute, options)
          hash
        end
      end

      private

      def invisible_columns
        @invisible_columns ||= [model.primary_key, "created_at", "updated_at"]
      end
    end
  end
end
