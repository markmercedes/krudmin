class PassengersResourceManager < Krudmin::ResourceManagers::Base
  EDITABLE_ATTRIBUTES = [:name, :age, :gender]
  MODEL_CLASSNAME = "Passenger"
  RESOURCE_LABEL = "Passenger"
  RESOURCES_LABEL = "Passengers"

  ATTRIBUTE_TYPES = {
    name: Krudmin::Fields::String,
    age: Krudmin::Fields::Number,
    gender: [Krudmin::Fields::EnumType, {associated_options: -> { Passenger.genders }}]
  }
end
