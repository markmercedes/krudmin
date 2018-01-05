module Krudmin
  module ResourceManagers
    class Routing

      attr_reader :resource_name, :namespace
      def initialize(resource_name, namespace = nil)
        @resource_name = resource_name
        @namespace = namespace
      end

      def new_resource_path
        routes.send(new_route_path)
      end

      def activate_path(given_model)
        routes.send(activate_route_path, given_model)
      end

      def deactivate_path(given_model)
        routes.send(deactivate_route_path, given_model)
      end

      def resource_path(given_model)
        routes.send(resource_route_path, given_model)
      end

      def edit_resource_path(given_model, params = {})
        routes.send(edit_route_path, given_model, params)
      end

      def resource_root
        routes.send("#{path}#{resources}_path")
      end

      def resource
        @resource ||= resource_name.to_s.underscore
      end

      def resources
        @resources ||= resource_name.to_s.pluralize.underscore
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

      def routes
        Rails.application.routes.url_helpers
      end
    end
  end
end
