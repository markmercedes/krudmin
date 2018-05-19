require_relative "./has_many"
require_relative "../presenters/belongs_to_one_field_presenter"

module Krudmin
  module Fields
    class BelongsToOne < HasMany
      PRESENTER = Krudmin::Presenters::BelongsToOneFieldPresenter
    end
  end
end
