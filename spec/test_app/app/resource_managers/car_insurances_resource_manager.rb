class CarInsurancesResourceManager < Krudmin::ResourceManagers::Base
  MODEL_CLASSNAME = "CarInsurance"

  EDITABLE_ATTRIBUTES = [:license_number, :date]
  RESOURCE_INSTANCE_LABEL_ATTRIBUTE = :id

  ATTRIBUTE_TYPES = {
    date: :Date
  }
end
