module Krudmin
  class CustomController < Krudmin::Config.parent_controller.constantize
    include Krudmin::KrudminControllerSupport
    include Krudmin::ActionButtonsSupport
    extend Krudmin::HelperIncluder
    include_helper Krudmin::ApplicationHelper

    layout Krudmin::Config.theme

    before_action :set_view_path

    private

    def set_view_path
      lookup_context.prefixes.append Krudmin::Config.theme
    end
  end
end
