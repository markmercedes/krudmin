module Krudmin
  module ActionButtons
    class NewButton < Base
      def initialize(page, view_context, action_path = nil, html_options = {}, &block)
        super

        @action_path ||= view_context.new_resource_path
      end
    end
  end
end
