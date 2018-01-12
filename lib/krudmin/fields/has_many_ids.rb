module Krudmin
  module Fields
    class HasManyIds < HasMany
      def self.editable_attribute(attribute)
        attribute
      end

      def editable_attribute
        {"#{attribute}_ids".to_sym => []}
      end
    end
  end
end
