module Krudmin
  module ActionButtonsSupport
    extend ActiveSupport::Concern

    included do
      helper_method :configure_toolbar, :list_action_panel
    end

    def configure_toolbar(page, h, &block)
      Toolbar.configure(page, h, &block)
    end

    def list_action_panel(model, actions, h, &block)
      ListActionPanel.for(model, actions, h, &block)
    end
  end
end
