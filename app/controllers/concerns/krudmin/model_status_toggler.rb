module Krudmin
  module ModelStatusToggler
    def activate
      Krudmin::MutationHandlers::SwitchOnHandler.(self, :activate, activated_message, cant_be_activated_message)
    end

    def deactivate
      Krudmin::MutationHandlers::SwitchOffHandler.(self, :deactivate, deactivated_message, cant_be_deactivated_message)
    end
  end
end
