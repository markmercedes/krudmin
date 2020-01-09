module Krudmin
  class PasswordsController < Devise::PasswordsController
    layout "krudmin/sessions"
  end
end
