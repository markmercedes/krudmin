module Krudmin
  module Config
    class << self
      def with
        yield(self)

        after_config_received

        self
      end

      def after_config_received
      end

      attr_writer :navigation_menu, :parent_controller, :krudmin_root_path, :pundit_enabled, :theme, :layout
      attr_accessor :form_wrapper, :modal_form_wrapper

      attr_accessor :edit_profile_path, :logout_path

      DEFAULT_CURRENT_USER = proc {}

      DEFAULT_PARENT_CONTROLLER_CLASS = "ActionController::Base"

      DEFAULT_ROOT_PATH = "#"

      DEFAULT_THEME = "krudmin/core_theme"

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

      def navigation_menu
        @_nav_menu = (@navigation_menu || -> { Krudmin::NavigationMenu.new }).call
      end

      def theme
        @theme || DEFAULT_THEME
      end

      def layout
        @layout || theme
      end
    end
  end
end
