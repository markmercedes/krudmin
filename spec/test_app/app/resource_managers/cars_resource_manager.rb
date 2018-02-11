class CarsResourceManager < Krudmin::ResourceManagers::Base
  MODEL_CLASSNAME = "Car"

  EDITABLE_ATTRIBUTES = {
    general: [:active, :description, :created_at, :release_date],
    activation: [:model, :year, :car_brand_id, :transmission],
    passengers: [:passengers],
  }
  DISPLAYABLE_ATTRIBUTES = [:id, :model, :year, :description, :transmission, :car_brand_id, :passengers, :created_at]
  SEARCHABLE_ATTRIBUTES = [:model, :year, :active, :car_brand_id, :transmission, :created_at]
  LISTABLE_ACTIONS = [:show, :edit, :active, :destroy]
  LISTABLE_ATTRIBUTES = [:model, :id, :car_brand_description, :year, :active, :description, :created_at]
  LISTABLE_INCLUDES = [:car_brand]

  ORDER_BY = [:year]

  RESOURCE_INSTANCE_LABEL_ATTRIBUTE = :model
  RESOURCE_LABEL = "Car"
  RESOURCES_LABEL = "Cars"

  PRESENTATION_METADATA = {
    general: { label: "General Info", class: "col-lg-6 col-md-12" },
    activation: { label: "Activation", class: "col-lg-6 col-md-12" },
    passengers: { label: "Passengers", class: "col-md-12" },
  }

  ATTRIBUTE_TYPES = {
    id: { type: Krudmin::Fields::Number, padding: 10, prefix: :CK },
    model: { type: Krudmin::Fields::Text, input: { rows: 2 } },
    description: { type: Krudmin::Fields::RichText, show_length: 20 },
    year: Krudmin::Fields::Number,
    active: Krudmin::Fields::Boolean,
    passengers: Krudmin::Fields::HasMany,
    car_brand_id: { type: Krudmin::Fields::BelongsTo, collection_label_field: :description, association_path: :admin_car_brand_path },
    created_at: { type: Krudmin::Fields::DateTime, format: :short },
    release_date: { type: Krudmin::Fields::Date, format: :short },
    transmission: { type: Krudmin::Fields::EnumType, associated_options: -> { Car.transmissions } },
  }
end
