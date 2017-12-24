class Krudmin::CarsManager < Krudmin::ResourceManagers::Base
  MODEL_CLASSNAME = "Car"
  LISTABLE_ATTRIBUTES = [:model, :year, :active]
  EDITABLE_ATTRIBUTES = [:model, :year, :active]
  SEARCHABLE_ATTRIBUTES = [:model, :year, :active]
  LISTABLE_ACTIONS = [:show, :edit, :destroy, :active]
  ORDER_BY = [:year]
  RESOURCE_INSTANCE_LABEL_ATTRIBUTE = :model
  PREPEND_ROUTE_PATH = :admin
  RESOURCE_NAME = "car"
  RESOURCE_LABEL = "Car"
  RESOURCES_LABEL = "Cars"
end
