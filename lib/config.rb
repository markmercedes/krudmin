module Krudmin
  module Config
    class << self
      def with(&block)
        yield(self)
        self
      end

      attr_writer :menu_items, :parent_controller, :krudmin_root_path

      attr_accessor :edit_profile_path, :logout_path

      DEFAULT_CURRENT_USER = proc {}

      DEFAULT_PARENT_CONTROLLER_CLASS = 'ActionController::Base'

      DEFAULT_ROOT_PATH = '#'

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

      def menu_items
        @menu_items ||= proc { [] }
      end
    end
  end
end
