module Krudmin
  module ResourceManagers
    class Attribute
      delegate :html_class, to: :type

      attr_reader :attribute, :type, :options
      def initialize(attribute, type = Krudmin::Fields::String, options = {})
        @attribute = attribute
        @type = type
        @options = options
      end

      def new_field(model)
        type.new(attribute, model, options)
      end

      def type_as_hash
        @type_as_hash ||= type.type_as_hash(attribute, options)
      end

      def self.from_list(attribute_types)
        attribute_types.inject({}) {|hash, metadata|
          attribute = metadata.first
          options = metadata.last
          hash[attribute] = from(attribute, options)
          hash
        }
      end

      def self.from(attribute, field_metadata)
        return new(attribute) unless field_metadata

        if field_metadata.is_a?(Hash)
          new(attribute, field_metadata.fetch(:type), field_metadata.except(:type))
        else
          new(attribute, field_metadata)
        end
      end
    end
  end
end
