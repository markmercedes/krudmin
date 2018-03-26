module Krudmin
  class AppRouter
    attr_reader :routes

    def initialize(routes)
      @routes = routes
    end

    delegate :url_helpers, to: :routes

    def build(*args)
      url_helpers.send(*args)
    end

    def available_routes
      @available_routes ||= RouteMapper.(routes.router.routes)
    end

    def exists?(action, controller_path)
      available_routes[controller_path].include?(action.to_s)
    end

    class RouteMapper
      class << self
        def call(routes)
          new(routes).to_h
        end
      end

      attr_reader :routes
      def initialize(routes)
        @routes = routes
      end

      def to_h
        flatten_routes.reduce({}) do |hash, node|
          hash[node[:controller]] = hash.fetch(node[:controller], []).push(node[:action]).uniq

          hash
        end
      end

      private

      def flatten_routes
        @flatten_routes ||= routes.map(&:defaults)
      end
    end
  end
end
