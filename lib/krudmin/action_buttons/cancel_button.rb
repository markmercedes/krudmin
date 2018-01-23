module Krudmin
  module ActionButtons
    class CancelButton < Base
      def initialize(*)
        super
        @page = :base
      end

      def render_base
        render_partial(:base)
      end
    end
  end
end
