require_relative "../presenters/password_field_presenter"

module Krudmin
  module Fields
    class Password < Krudmin::Fields::String
      PRESENTER = Krudmin::Presenters::PasswordFieldPresenter
    end
  end
end
