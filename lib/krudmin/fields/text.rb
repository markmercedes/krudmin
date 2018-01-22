require_relative "../presenters/text_field_presenter"

module Krudmin
  module Fields
    class Text < Krudmin::Fields::String
      PRESENTER = Krudmin::Presenters::TextFieldPresenter
    end
  end
end
