module Krudmin
  module ResourceManagers
    class Routing
      attr_reader :routes, :resource_name, :namespace
      def initialize(routes, resource_name, namespace = nil)
        @routes = routes
        @resource_name = resource_name.to_s.singularize
        @namespace = namespace.present? ? namespace : nil
      end

      def new_resource_path
        routes.send(new_route_path)
      end

      def activate_path(given_model, *params)
        routes.send(activate_route_path, given_model, *params)
      end

      def deactivate_path(given_model, *params)
        routes.send(deactivate_route_path, given_model, *params)
      end

      def resource_path(given_model)
        routes.send(resource_route_path, given_model)
      end

      def edit_resource_path(given_model, params = {})
        routes.send(edit_route_path, given_model, params)
      end

      def resource_root(*params)
        routes.send("#{path}#{resources}_path", *params)
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
        "new_#{path}#{resource}_path"
      end

      def activate_route_path
        "activate_#{path}#{resource}_path"
      end

      def deactivate_route_path
        "deactivate_#{path}#{resource}_path"
      end

      def resource_route_path
        "#{path}#{resource}_path"
      end

      def edit_route_path
        "edit_#{path}#{resource}_path"
      end

      def path
        @path ||= namespace ? "#{namespace}_" : ""
      end
    end
  end
end
