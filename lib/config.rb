module Krudmin
  module Config
    class << self
      def with(&block)
        yield(self)
        self
      end

      attr_writer :menu_items, :parent_controller

      DEFAULT_CURRENT_USER = proc {}

      DEFAULT_PARENT_CONTROLLER_CLASS = 'ActionController::Base'

      def parent_controller
        @parent_controller || DEFAULT_PARENT_CONTROLLER_CLASS
      end

      def current_user_method(&block)
        @current_user = block if block
        @current_user || DEFAULT_CURRENT_USER
      end

      def menu_items
        @menu_items ||= []
      end
    end
  end
end
