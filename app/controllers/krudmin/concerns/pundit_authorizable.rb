module Krudmin
  module PunditAuthorizable
    extend ActiveSupport::Concern
    include Pundit

    included do |_|
      before_action :authorize_model, only: [:new, :edit, :show, :update, :activate, :deactivate, :destroy]
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
      def authorize_model(given_model = model)
        authorize given_model
      end

      def scope
        policy_scope(super)
      end

      def item_list
        policy_scope(super)
      end
    end
  end
end
