module Krudmin
  module ResourceManagers
    class Attribute
      delegate :html_class, to: :type

      class NoPresentationMedatataFound < StandardError; end

      attr_reader :attribute, :type, :options
      def initialize(attribute, type = Krudmin::Fields::String, options = {})
        @attribute = attribute
        @type = find_field_klass(type)
        @options = options
      end

      def new_field(model)
        type.new(attribute, model, options)
      end

      def type_as_hash
        @type_as_hash ||= type.type_as_hash(attribute, options)
      end

      private

      def find_field_klass(source)
        case source
        when Symbol, String
          "Krudmin::Fields::#{source}".constantize
        else
          source
        end
      end

      class << self
        def from_inferred_type(attribute, active_record_type)
          type = Krudmin::Fields::Inflector.field_from_active_record(active_record_type)

          new(attribute, type)
        end

        def from_list(attribute_types)
          attribute_types.reduce({}) { |hash, metadata|
            attribute = metadata.first
            hash[attribute] = from(attribute, metadata.last)
            hash
          }
        end

        def from(attribute, field_metadata)
          return new(attribute) unless field_metadata

          if field_metadata.is_a?(Hash)
            new(attribute,
                field_metadata.fetch(:type) { fail NoPresentationMedatataFound.new("No presentation key found for `#{attribute}`") },
                field_metadata.except(:type)
              )
          else
            new(attribute, field_metadata)
          end
        end
      end
    end
  end
end
