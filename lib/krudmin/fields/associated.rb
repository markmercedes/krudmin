module Krudmin
  module Fields
    class Associated < Base
      def associated_class
        associated_class_name.constantize
      end

      def associated_class_name
        @associated_class_name ||= options.fetch(:class_name) { association_name.to_s.singularize.camelcase }
      end

      def association_name
        @association_name ||= options.fetch(:association_name) { attribute.to_s.gsub("_id", "").to_sym }
      end

      def foreign_key
        @foreign_key ||= options.fetch(:foreign_key, attribute)
      end

      def primary_key
        @primary_key ||= options.fetch(:primary_key, :id)
      end

      def association_predicate
        @association_predicate ||= options.fetch(:association_predicate, ->(source) { source.all })
      end
    end
  end
end
