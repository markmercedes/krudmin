class CarsResourceManager < Krudmin::ResourceManagers::Base
  MODEL_CLASSNAME = "Car"

  EDITABLE_ATTRIBUTES = {
    general: [:active, :description],
    activation: [:model, :year, :car_brand_id],
    passengers: [:passengers]
  }

  SEARCHABLE_ATTRIBUTES = [:model, :year, :active]
  LISTABLE_ACTIONS = [:show, :edit, :destroy, :active]
  LISTABLE_ATTRIBUTES = [:model, :year, :description]
  ORDER_BY = [:year]
  RESOURCE_INSTANCE_LABEL_ATTRIBUTE = :model
  RESOURCE_LABEL = "Car"
  RESOURCES_LABEL = "Cars"

  PRESENTATION_METADATA = {
    general: { label: "GENERALISIMO", class: "col-lg-6 col-md-12" },
    activation: { label: "Activation", class: "col-lg-6 col-md-12" },
    passengers: { label: "Passengers", class: "col-md-12" }
  }

  ATTRIBUTE_TYPES = {
    id: Krudmin::Fields::Number,
    model: {type: Krudmin::Fields::Text, input: {rows: 2}},
    description: {type: Krudmin::Fields::RichText, show_length: 20},
    year: Krudmin::Fields::Number,
    active: Krudmin::Fields::String,
    passengers: Krudmin::Fields::HasMany,
    car_brand_id: {type: Krudmin::Fields::BelongsTo, collection_label_field: :description},
  }
end
