require_relative "../presenters/hidden_field_presenter"

module Krudmin
  module Fields
    class Hidden < Base
      PRESENTER = Krudmin::Presenters::HiddenFieldPresenter
      HTML_CLASS = "no-padding"
    end
  end
end
