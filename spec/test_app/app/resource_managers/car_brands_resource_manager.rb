class CarBrandsResourceManager < Krudmin::ResourceManagers::Base
  MODEL_CLASSNAME = "CarBrand"

  EDITABLE_ATTRIBUTES = [:description]

  SEARCHABLE_ATTRIBUTES = [:description]
  LISTABLE_ACTIONS = [:show, :edit, :destroy]
  LISTABLE_ATTRIBUTES = [:description]
  ORDER_BY = [:description]
  RESOURCE_INSTANCE_LABEL_ATTRIBUTE = :description
  RESOURCE_LABEL = "Car Brand"
  RESOURCES_LABEL = "Car Brands"
end
