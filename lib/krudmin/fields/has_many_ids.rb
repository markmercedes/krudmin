module Krudmin
  module Fields
    class HasManyIds < BelongsTo
      def permitted_attribute
        { attribute => [] }
      end

      def input_type
        options.fetch(:input_type, :select)
      end
    end
  end
end
