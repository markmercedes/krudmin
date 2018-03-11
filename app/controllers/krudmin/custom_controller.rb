module Krudmin
  class CustomController < Krudmin::Config.parent_controller.constantize
    include Krudmin::KrudminControllerSupport
    include Krudmin::ActionButtonsSupport
    include Krudmin::ApplicationHelper

    layout Krudmin::Config.theme

    before_action :set_view_path

    private

    def set_view_path
      lookup_context.prefixes.append Krudmin::Config.theme
    end
  end
end
