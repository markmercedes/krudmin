module Krudmin
  module Fields
    module Inflector
      class << self
        # TODO: autosupport for HasMany and BelongsTo
        def field_from_active_record(type)
          case type
          when :string
            Krudmin::Fields::String
          when :text
            Krudmin::Fields::Text
          when :integer, :bigint, :float, :decimal, :numeric
            Krudmin::Fields::Number
          when :datetime, :time
            Krudmin::Fields::DateTime
          when :date
            Krudmin::Fields::Date
          when :boolean
            Krudmin::Fields::Boolean
          else
            Krudmin::Fields::String
          end
        end
      end
    end
  end
end
