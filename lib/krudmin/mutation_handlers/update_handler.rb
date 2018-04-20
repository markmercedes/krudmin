module Krudmin
  module MutationHandlers
    class UpdateHandler < CreateHandler
      def on_error_view
        "edit"
      end
    end
  end
end
