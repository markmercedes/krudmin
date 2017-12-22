module Krudmin
  module Config
    class << self
      def with(&block)
        yield(self)
        self
      end

      attr_writer :menu_items

      DEFAULT_CURRENT_USER = proc {}

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
