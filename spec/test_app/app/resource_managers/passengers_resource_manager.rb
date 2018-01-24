class PassengersResourceManager < Krudmin::ResourceManagers::Base
  EDITABLE_ATTRIBUTES = [:name, :age, :gender, :email]
  MODEL_CLASSNAME = "Passenger"

  ATTRIBUTE_TYPES = {
    name: Krudmin::Fields::String,
    age: Krudmin::Fields::Number,
    email: Krudmin::Fields::Email,
    gender: {type: Krudmin::Fields::EnumType, associated_options: -> { Passenger.genders }}
  }
end
