class CarsResourceManager < Krudmin::ResourceManagers::Base
  MODEL_CLASSNAME = "Car"

  EDITABLE_ATTRIBUTES = {
    general: [:active, :description, :created_at, :release_date],
    activation: [:model, :year, :car_brand_id, :transmission],
    passengers: [:passengers],
    insurance: [:car_insurance],
    owner: [:car_owner]
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
    insurance: { label: "Insurance", class: "col-md-6" },
    owner: { label: "Owner", class: "col-md-6" },
  }

  ATTRIBUTE_TYPES = {
    id: { type: :Number, padding: 10, prefix: :CK },
    model: { type: :Text, input: { rows: 2 } },
    description: { type: :RichText, show_length: 20 },
    year: :Number,
    active: { type: :Boolean, input: { label: 'Is Active'} },
    passengers: :HasMany,
    car_brand_id: { type: :BelongsTo, collection_label_field: :description, association_path: :car_brand_path, add_path: :new_car_brand, edit_path: :edit_car_brand, remote: true },
    created_at: { type: :DateTime, format: :short },
    release_date: { type: :Date, format: :short },
    transmission: { type: :EnumType, associated_options: -> { Car.transmissions } },
    car_insurance: :HasOne,
    car_owner: :BelongsToOne
  }
end
