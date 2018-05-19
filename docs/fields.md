| Type         | Class                           | Description                                                                                                           |
| ------------ | ------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| Base         | `Krudmin::Fields::Base`         | Base field class from which all the other field classes inherit                                                       |
| Associated   | `Krudmin::Fields::Associated`   | Base field class for types that need to have a relation with other model (`belongs_to`, `has_one`, `has_many`)        |
| BelongsTo    | `Krudmin::Fields::BelongsTo`    | Renders a dropdown with a list of options                                                                             |
| BelongsToOne | `Krudmin::Fields::BelongsToOne` | Renders a nested form with all the properties of the associated record, associated record requires a resource manager |
| Boolean      | `Krudmin::Fields::Boolean`      |                                                                                                                       |
| Currency     | `Krudmin::Fields::Currency`     |                                                                                                                       |
| DateTime     | `Krudmin::Fields::DateTime`     |                                                                                                                       |
| Date         | `Krudmin::Fields::Date`         |                                                                                                                       |
| Decimal      | `Krudmin::Fields::Decimal`      |                                                                                                                       |
| Email        | `Krudmin::Fields::Email`        |                                                                                                                       |
| EnumType     | `Krudmin::Fields::EnumType`     |                                                                                                                       |
| HasManyIds   | `Krudmin::Fields::HasManyIds`   |                                                                                                                       |
| HasMany      | `Krudmin::Fields::HasMany`      |                                                                                                                       |
| HasOne       | `Krudmin::Fields::HasOne`       |                                                                                                                       |
| Number       | `Krudmin::Fields::Number`       |                                                                                                                       |
| RichText     | `Krudmin::Fields::RichText`     |                                                                                                                       |
| String       | `Krudmin::Fields::String`       |                                                                                                                       |
| Text         | `Krudmin::Fields::Text`         |                                                                                                                       |
