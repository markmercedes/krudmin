class UsersResourceManager < Krudmin::ResourceManagers::Base
  MODEL_CLASSNAME = "Krudmin::User"
  LISTABLE_ATTRIBUTES = [:name, :email, :role, :active]
  EDITABLE_ATTRIBUTES = [:name, :email, :role, :active, :password, :password_confirmation]
  LISTABLE_ACTIONS = [:show, :edit, :active, :destroy]
  SEARCHABLE_ATTRIBUTES = [:name, :email, :active]
  RESOURCE_INSTANCE_LABEL_ATTRIBUTE = :name
  RESOURCE_NAME = "user"
  RESOURCE_LABEL = "User"
  RESOURCES_LABEL = "Users"
  REMOTE_CRUD = true

  ATTRIBUTE_TYPES = {
    active: Krudmin::Fields::Boolean,
    password: Krudmin::Fields::Boolean,
    password_confirmation: Krudmin::Fields::Boolean,
    role: { type: Krudmin::Fields::EnumType, associated_options: -> { Krudmin::User.roles } },
  }
end
