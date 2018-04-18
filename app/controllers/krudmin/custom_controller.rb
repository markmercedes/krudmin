module Krudmin
  class CustomController < ActionController::Base
    include Krudmin::KrudminControllerSupport
    include Krudmin::ActionButtonsSupport
    extend Krudmin::HelperIncluder
    include_helper Krudmin::ApplicationHelper

    layout Krudmin::Config.layout
  end
end
