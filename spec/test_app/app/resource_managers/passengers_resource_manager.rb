class PassengersResourceManager < Krudmin::ResourceManagers::Base
  EDITABLE_ATTRIBUTES = [:name, :age, :gender, :email]
  MODEL_CLASSNAME = "Passenger"

  ATTRIBUTE_TYPES = {
    name: "String",
    age: "Number",
    email: :Email,
    gender: {type: :EnumType, associated_options: -> { Passenger.genders }}
  }
end
