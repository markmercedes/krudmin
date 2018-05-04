module Krudmin
  module KrudminControllerSupport
    extend ActiveSupport::Concern

    included do
      helper_method :navigation_menu, :_current_user, :krudmin_root_path, :model_id
    end

    def krudmin_router
      @krudmin_router ||= Krudmin::ResourceManagers::Routing.from(AppRouter.new(Rails.application.routes), krudmin_routing_path)
    end

    def krudmin_routing_path
      controller_path
    end

    def _current_user
      instance_eval(&Krudmin::Config.current_user_method)
    end

    def krudmin_root_path
      @krudmin_root_path ||= Rails.application.routes.url_helpers.send(Krudmin::Config.krudmin_root_path)
    end

    def navigation_menu
      @navigation_menu ||= Krudmin::Config.navigation_menu.for(_current_user)
    end

    def model_id
      @model_id ||= params[:id]
    end
  end
end
