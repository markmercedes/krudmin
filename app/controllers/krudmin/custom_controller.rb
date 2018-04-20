module Krudmin
  class CustomController < Krudmin::Config.parent_controller.constantize
    include Krudmin::KrudminControllerSupport
    include Krudmin::ActionButtonsSupport
    extend Krudmin::HelperIncluder
    include_helper Krudmin::ApplicationHelper

    layout Krudmin::Config.layout
  end
end
