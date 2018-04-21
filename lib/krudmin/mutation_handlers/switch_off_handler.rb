module Krudmin
  module MutationHandlers
    class SwitchOffHandler < SwitchOnHandler
      SUCCESS_FLASH_TYPE = :warning
    end
  end
end
