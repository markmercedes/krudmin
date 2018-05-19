require_relative "./has_many"
require_relative "../presenters/has_one_field_presenter"

module Krudmin
  module Fields
    class HasOne < HasMany
      PRESENTER = Krudmin::Presenters::HasOneFieldPresenter
    end
  end
end
