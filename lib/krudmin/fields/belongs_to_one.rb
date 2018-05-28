require_relative "./has_one"
require_relative "../presenters/belongs_to_one_field_presenter"

module Krudmin
  module Fields
    class BelongsToOne < HasOne
      PRESENTER = Krudmin::Presenters::BelongsToOneFieldPresenter
    end
  end
end
