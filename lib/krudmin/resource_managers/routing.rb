module Krudmin
  module ResourceManagers
    class Routing
      DEFINED_ACTION_METHODS = [:edit, :show, :destroy, :new, :activate, :deactivate].freeze

      DEFINED_ACTION_METHODS.each do |action_name|
        define_method("#{action_name}_route?") do
          exists?(action_name)
        end
      end

      attr_reader :routes, :resource_name, :namespace
      def initialize(routes, resource_name, namespace = nil)
        @routes = routes
        @resource_name = resource_name.to_s.singularize
        @namespace = namespace.present? ? namespace : nil
      end

      def new_resource_path
        routes.build(new_route_path)
      end

      def activate_path(given_model, *params)
        routes.build(activate_route_path, given_model, *params)
      end

      def deactivate_path(given_model, *params)
        routes.build(deactivate_route_path, given_model, *params)
      end

      def resource_path(given_model)
        routes.build(resource_route_path, given_model)
      end

      def edit_resource_path(given_model, params = {})
        routes.build(edit_route_path, given_model, params)
      end

      def exists?(action_name, path = nil)
        routes.exists?(action_name, path || controller_path)
      end

      def resource_root(*params)
        routes.build("#{path}#{resources}_path", *params)
      end

      def resource
        @resource ||= resource_name.to_s.underscore
      end

      def resources
        @resources ||= resource_name.to_s.pluralize.underscore
      end

      def self.from(routes, controller_path)
        path_parts = controller_path.split("/")

        new(routes, path_parts.last, path_parts[0..-2].join("/"))
      end

      private

      def new_route_path
        "new_#{resource_method_path}_path"
      end

      def activate_route_path
        "activate_#{resource_method_path}_path"
      end

      def deactivate_route_path
        "deactivate_#{resource_method_path}_path"
      end

      def resource_route_path
        "#{resource_method_path}_path"
      end

      def edit_route_path
        "edit_#{resource_method_path}_path"
      end

      def path
        @path ||= namespace ? "#{namespace}_" : ""
      end

      def controller_path
        @controller_path ||= namespace.present? ? "#{namespace}/#{resources}" : resource
      end

      def resource_method_path
        "#{path}#{resource}"
      end
    end
  end
end
