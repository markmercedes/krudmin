class CarsResourceManager < Krudmin::ResourceManagers::Base
  MODEL_CLASSNAME = "Car"

  EDITABLE_ATTRIBUTES = {
    general: [:active, :description],
    activation: [:model, :year, :car_brand_id, :transmission],
    passengers: [:passengers]
  }
  DISPLAYABLE_ATTRIBUTES = [:model, :year, :description, :transmission, :passengers, :created_at]
  SEARCHABLE_ATTRIBUTES = [:model, :year, :active, :car_brand_id, :transmission, :created_at]
  LISTABLE_ACTIONS = [:show, :edit, :destroy, :active]
  LISTABLE_ATTRIBUTES = [:model, :id, :car_brand_description, :year, :active, :description, :created_at]
  ORDER_BY = [:year]
  LISTABLE_INCLUDES = [:car_brand]
  RESOURCE_INSTANCE_LABEL_ATTRIBUTE = :model
  RESOURCE_LABEL = "Car"
  RESOURCES_LABEL = "Cars"

  PRESENTATION_METADATA = {
    general: { label: "General Info", class: "col-lg-6 col-md-12" },
    activation: { label: "Activation", class: "col-lg-6 col-md-12" },
    passengers: { label: "Passengers", class: "col-md-12" }
  }

  ATTRIBUTE_TYPES = {
    id: {type: Krudmin::Fields::Number, padding: 10},
    model: {type: Krudmin::Fields::Text, input: {rows: 2}},
    description: {type: Krudmin::Fields::RichText, show_length: 20},
    year: Krudmin::Fields::Number,
    active: Krudmin::Fields::Boolean,
    passengers: Krudmin::Fields::HasMany,
    car_brand_id: {type: Krudmin::Fields::BelongsTo, collection_label_field: :description},
    created_at: {type: Krudmin::Fields::DateTime, format: :short},
    transmission: {type: Krudmin::Fields::EnumType, associated_options: -> { Car.transmissions }}
    # {type: Krudmin::Fields::DateTime, format: :short}
  }
end
