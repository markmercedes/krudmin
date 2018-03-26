module Krudmin
  module Authorizable
    if Krudmin::Config.pundit_enabled?
      extend ActiveSupport::Concern
      include Pundit

      included do |_|
        before_action :authorize_model, only: [:new, :edit, :show, :update, :activate, :deactivate, :destroy]
        before_action :authorize_scope, only: [:index]

        prepend ModelAuthorizer
        include GranularAccessControl
      end

      def authorize_scope
        authorize scope
      end

      def pundit_user
        _current_user
      end

      module ModelAuthorizer
        def authorize_model(given_model = model)
          authorize super(given_model)
        end

        def scope
          policy_scope(super)
        end

        def item_list
          policy_scope(super)
        end
      end

      module GranularAccessControl
        [:edit, :show, :destroy, :activate, :deactivate].each do |action_name|
          define_method("#{action_name}_access?") do |record|
            policy(record).public_send("#{action_name}?")
          end
        end
      end
    end
  end
end
