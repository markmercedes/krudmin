class CarBrandsResourceManager < Krudmin::ResourceManagers::Base
  MODEL_CLASSNAME = "CarBrand"

  LISTABLE_ACTIONS = [:show, :edit, :destroy]
  ORDER_BY = [:description]
  RESOURCE_INSTANCE_LABEL_ATTRIBUTE = :description
  RESOURCE_LABEL = "Car Brand"
  RESOURCES_LABEL = "Car Brands"
end
