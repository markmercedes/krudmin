class PassengersResourceManager < Krudmin::ResourceManagers::Base
  EDITABLE_ATTRIBUTES = [:name, :age, :gender]
  MODEL_CLASSNAME = "Passenger"

  ATTRIBUTE_TYPES = {
    name: Krudmin::Fields::String,
    age: Krudmin::Fields::Number,
    gender: {type: Krudmin::Fields::EnumType, associated_options: -> { Passenger.genders }}
  }
end
