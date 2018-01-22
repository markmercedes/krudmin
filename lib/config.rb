module Krudmin
  module Config
    class << self
      def with
        yield(self)

        after_config_received

        self
      end

      def after_config_received
        configure_pundit
      end

      def configure_pundit
        if Krudmin::Config.pundit_enabled?
          Krudmin::ApplicationController.class_eval do
            include Krudmin::PunditAuthorizable
          end
        end
      end

      attr_writer :menu_items, :parent_controller, :krudmin_root_path, :pundit_enabled

      attr_accessor :edit_profile_path, :logout_path

      DEFAULT_CURRENT_USER = proc {}

      DEFAULT_PARENT_CONTROLLER_CLASS = "ActionController::Base"

      DEFAULT_ROOT_PATH = "#"

      def krudmin_root_path
        @krudmin_root_path || DEFAULT_ROOT_PATH
      end

      def parent_controller
        @parent_controller || DEFAULT_PARENT_CONTROLLER_CLASS
      end

      def current_user_method(&block)
        @current_user = block if block
        @current_user || DEFAULT_CURRENT_USER
      end

      def pundit_enabled?
        @pundit_enabled
      end

      def menu_items
        @menu_items ||= proc { [] }
      end
    end
  end
end
