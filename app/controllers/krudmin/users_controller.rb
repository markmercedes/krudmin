module Krudmin
  class UsersController < Krudmin::ApplicationController
    before_action Krudmin::Config.require_authenticated_user_method

    def send_reset_password_instructions
      model.send_reset_password_instructions
      render json: { success: true }, status: 200
    end

    private

    def model_params
      @model_params ||= begin
        _params = params.require(:user).permit(permitted_attributes)

        if _params[:password].blank?
          _params.delete(:password)
          _params.delete(:password_confirmation)
        end

        _params
      end
    end
  end
end
