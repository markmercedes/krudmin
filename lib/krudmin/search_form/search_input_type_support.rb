module Krudmin
  class SearchForm
    module SearchInputTypeSupport
      def real_field_for(field)
        field.to_s.gsub("__from", "").gsub("__to", "")
      end

      def search_criteria_for(key, value)
        input_type_for(real_field_for(key)).search_criteria_for(key, value)
      end

      def input_type_for(field)
        case model_class.type_for_attribute(field.to_s).type
        when :decimal, :integer, :bigint, :float
          Krudmin::Fields::Number
        when :date, :datetime, :timestamp
          Krudmin::Fields::DateTime
        when :boolean
          Krudmin::Fields::Boolean
        else
          Krudmin::Fields::String
        end
      end
    end
  end
end
