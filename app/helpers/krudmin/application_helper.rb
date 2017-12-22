module Krudmin
  module ApplicationHelper
    def current_user
      OpenStruct.new(name: "user", email: "user@example.com")
    end
  end
end
