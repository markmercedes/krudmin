require 'active_support/inflector'
require 'active_support/core_ext/module/delegation'

module Krudmin
  module ResourceManagers
    class Base
      include Enumerable

      delegate :each, to: :items

      MODEL_CLASSNAME = nil
      LISTABLE_ATTRIBUTES = []
      EDITABLE_ATTRIBUTES = []
      LISTABLE_ACTIONS = [:show, :edit, :destroy]
      ORDER_BY = []
      LISTABLE_INCLUDES = []
      RESOURCE_INSTANCE_LABEL_ATTRIBUTE = nil
      PREPEND_ROUTE_PATH = :krudmin
      RESOURCE_NAME = ""

      def self.constantized_methods(*attrs)
        attrs.flatten.each do |attr|
          define_method(attr) do
            self.class.const_get(attr.upcase)
          end
        end
      end

      constantized_methods :model_classname, :listable_attributes, :editable_attributes, :listable_actions, :order_by, :listable_includes, :resource_instance_label_attribute, :prepend_route_path

      def resource_name
        @resource_name ||= self.class::RESOURCE_NAME.to_s.underscore
      end

      def resources_name
        @resources_name ||= self.class::RESOURCE_NAME.to_s.pluralize.underscore
      end

      def new_resource_path
        routes.send(new_route_path)
      end

      def new_route_path
        "new_#{prepend_route_path}_#{resource_name}_path"
      end

      def activate_path(given_model)
        routes.send(activate_route_path, given_model)
      end

      def activate_route_path
        "activate_#{prepend_route_path}_#{resource_name}_path"
      end

      def deactivate_path(given_model)
        routes.send(deactivate_route_path, given_model)
      end

      def deactivate_route_path
        "deactivate_#{prepend_route_path}_#{resource_name}_path"
      end

      def resource_path(given_model)
        routes.send(resource_route_path, given_model)
      end

      def resource_route_path
        "#{prepend_route_path}_#{resource_name}_path"
      end

      def edit_resource_path(given_model, params = {})
        routes.send(edit_route_path, given_model, params)
      end

      def edit_route_path
        "edit_#{prepend_route_path}_#{resource_name}_path"
      end

      def resource_root
        routes.send("#{prepend_route_path}_#{resources_name}_path")
      end

      def editable_attributes
        self.class::EDITABLE_ATTRIBUTES.map do |field|
          field.is_a?(Hash) ? field.first.first : field
        end
      end

      def permitted_attributes
        self.class::EDITABLE_ATTRIBUTES
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

      protected

      def model_class
        @model_class ||= model_classname.constantize
      end

      def routes
        Rails.application.routes.url_helpers
      end
    end
  end
end
