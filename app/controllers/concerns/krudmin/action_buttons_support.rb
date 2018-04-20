module Krudmin
  module ActionButtonsSupport
    extend ActiveSupport::Concern

    included do
      helper_method :configure_toolbar, :list_action_panel
    end

    def configure_toolbar(page, view_context, &block)
      Toolbar.configure(page, view_context, &block)
    end

    def list_action_panel(model, actions, view_context, remote: false, &block)
      ListActionPanel.for(model, actions, view_context, remote: remote, &block)
    end
  end
end
