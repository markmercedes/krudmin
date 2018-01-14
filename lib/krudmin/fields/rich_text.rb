require_relative '../presenters/rich_text_field_presenter'

module Krudmin
  module Fields
    class RichText < Text
      PRESENTER = Krudmin::Presenters::RichTextFieldPresenter
    end
  end
end
