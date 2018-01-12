module Krudmin
  module PunditAuthorizable
    extend ActiveSupport::Concern
    include Pundit

    included do |base|
      before_action :authorize_model, only: [:edit, :show, :update, :activate, :deactivate]
      before_action :authorize_scope, only: [:index]

      prepend ModelAuthorizer
    end

    def authorize_scope
      authorize scope
    end

    def pundit_user
      _current_user
    end

    module ModelAuthorizer
      def authorize_model(_model = nil)
        authorize _model || model
      end

      def scope
        policy_scope(super)
      end
    end
  end
end
