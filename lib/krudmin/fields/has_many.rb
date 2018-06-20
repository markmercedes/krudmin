require_relative "../presenters/has_many_field_presenter"

module Krudmin
  module Fields
    class HasMany < Associated
      PRESENTER = Krudmin::Presenters::HasManyFieldPresenter

      delegate :partial_form, :child_partial_form, :partial_display, :child_partial_display, to: :presenter_instance

      def associated_collection
        @associated_collection ||= association_predicate.call(associated_resource_manager_class.new.items)
      end

      def associated_class
        associated_class_name.constantize
      end

      def associated_class_name
        @associated_class_name ||= options.fetch(:class_name) { singularize_class_name.camelcase }
      end

      def association_name
        @association_name ||= options.fetch(:association_name) { attribute.to_sym }
      end

      def singularize_class_name
        association_name.to_s.singularize
      end

      def primary_key
        @primary_key ||= options.fetch(:model_key, :id)
      end

      def foreign_key
        @foreign_key ||= options.fetch(:foreign_key, "#{model.class.table_name.singularize}_id".to_sym)
      end

      def primary_key_value
        model.send(primary_key)
      end

      def association_predicate
        @association_predicate ||= options.fetch(:association_predicate, ->(source) { source.where(foreign_key => primary_key_value) })
      end

      def self.permitted_attribute(attribute)
        new(attribute).permitted_attribute
      end

      def permitted_attribute
        { "#{attribute}_attributes".to_sym => [:id, *associated_resource_manager_class.editable_attributes, :_destroy] }
      end

      def self.type_as_hash(attribute, options)
        {
          attribute => options,
          __attributes: Krudmin::ResourceManagers::Attribute.from_list(new(attribute, nil, options).associated_resource_manager_class::ATTRIBUTE_TYPES),
        }
      end
    end
  end
end
