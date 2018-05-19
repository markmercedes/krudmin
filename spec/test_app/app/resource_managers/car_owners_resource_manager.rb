class CarOwnersResourceManager < Krudmin::ResourceManagers::Base
  MODEL_CLASSNAME = "CarOwner"
  EDITABLE_ATTRIBUTES = [:name, :license_number]
  RESOURCE_INSTANCE_LABEL_ATTRIBUTE = :name
end
