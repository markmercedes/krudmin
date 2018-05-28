require_relative "./has_many"
require_relative "../presenters/has_one_field_presenter"

module Krudmin
  module Fields
    class HasOne < HasMany
      PRESENTER = Krudmin::Presenters::HasOneFieldPresenter

      def parse(value)
        value.to_h.reduce({}) do |hash, (key, value)|
          hash[key] = associated_resource_manager.field_class_for(key.to_sym).parse_with_field(value)

          hash
        end
      end
    end
  end
end
