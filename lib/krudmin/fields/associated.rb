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

      def associated_resource_manager_class_name
        @associated_resource_manager_class_name ||= options.fetch(:resource_manager, inferred_resource_manager).to_s
      end

      def associated_resource_manager_class
        @associated_resource_manager_class ||= associated_resource_manager_class_name.constantize rescue nil
      end

      def associated_resource_manager
        @associated_resource_manager ||= associated_resource_manager_class.new
      end

      def add_path
        options[:add_path]
      end

      def edit_path
        options[:edit_path]
      end

      private

      def inferred_resource_manager
        "#{associated_class_name.pluralize}ResourceManager"
      end
    end
  end
end
