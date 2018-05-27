module Krudmin
  module ResourceManagers
    class AssociatedTypeResolver
      attr_reader :field_name, :model

      def initialize(field_name, model)
        @field_name = field_name
        @model = model
      end

      def self.call(field_name, model)
        new(field_name, model).associated_type
      end

      def associated_type
        model_associated_field.each { |relation| find(relation)&.type }
      end

      def find(relation)
        model.reflections[relation].active_record.columns_hash[field_name.gsub("#{relation}_", "")]
      end

      def model_associated_field
        model.reflections.keys.select { |s| field_name.start_with?(s) }.sort_by(&:length).reverse
      end
    end
  end
end
