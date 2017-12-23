class Krudmin::CarsManager < Krudmin::ResourceManagers::Base
  MODEL_CLASSNAME = "Car"
  LISTABLE_ATTRIBUTES = [:model, :year]
  EDITABLE_ATTRIBUTES = [:model, :year]
  SEARCHABLE_ATTRIBUTES = [:model, :year]
  ORDER_BY = [:year]
  RESOURCE_INSTANCE_LABEL_ATTRIBUTE = :model
  PREPEND_ROUTE_PATH = :admin
  RESOURCE_NAME = "car"
  RESOURCE_LABEL = "Car"
  RESOURCES_LABEL = "Cars"
end
