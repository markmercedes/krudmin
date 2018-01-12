module Krudmin
  module Fields
    class HasMany < Associated
      def associated_collection
        @associated_collection ||= association_predicate.call(associated_class)
      end

      def associated_class
        associated_class_name.constantize
      end

      def associated_class_name
        @associated_class_name ||= options.fetch(:class_name) { association_name.to_s.camelcase }
      end

      def association_name
        @association_name ||= options.fetch(:association_name) { attribute.to_sym }
      end

      def foreign_key
        @foreign_key ||= options.fetch(:foreign_key, "#{association_name.to_s.singularize}_id".to_sym)
      end

      def primary_key
        @primary_key ||= options.fetch(:primary_key, :id)
      end

      def association_predicate
        @association_predicate ||=  options.fetch(:association_predicate, -> (source) { source.where(foreign_key => primary_key) })
      end

      def associated_resource_manager_class_name
        @associated_resource_manager_class_name ||= options.fetch(:resource_manager, inferred_resource_manager).to_s
      end

      def associated_resource_manager_class
        @associated_resource_manager_class ||= associated_resource_manager_class_name.constantize
      end

      def render_form(page, h, options)
        h.render(partial: partial_form, locals: {options: options, page: page, field: self})
      end

      def partial_form
        options.fetch(:partial_form, "has_many_form")

      end

      def child_partial_form
        options.fetch(:child_partial_form, "has_many_fields")
      end

      def self.editable_attribute(attribute)
        new(attribute).editable_attribute
      end

      def editable_attribute
        {"#{attribute}_attributes".to_sym => [:id, *associated_resource_manager_class.editable_attributes, :_destroy]}
      end

      def self.type_as_hash(attribute, options)
        {
          attribute => options,
          __attributes: Krudmin::ResourceManagers::Attribute.from_list(new(attribute).associated_resource_manager_class::ATTRIBUTE_TYPES)
        }
      end

      private

      def inferred_resource_manager
        "#{associated_class_name.pluralize}ResourceManager"
      end
    end
  end
end
