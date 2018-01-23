module Krudmin
  module Fields
    class HasManyIds < HasMany
      def editable_attribute
        { "#{attribute}_ids".to_sym => [] }
      end
    end
  end
end
