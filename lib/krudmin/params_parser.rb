module Krudmin
  class ParamsParser
    attr_reader :params, :resource_manager
    def initialize(params, resource_manager)
      @params = params
      @resource_manager = resource_manager
    end

    def to_h
      params.to_h.reduce(params.class.new) do |hash, item|
        field = item.first.to_sym

        hash[field] = find_resource_field_from(field).parse_with_field(params[field])

        hash
      end
    end

    private

    # TODO: Refactor this method, looks dirty, encapsulate logic into new class
    def resolve_association(field)
      associated_type = resource_manager.find_type_for(field)

      if associated_type.is_a?(Symbol)
        associated_type
      elsif associated_type.is_a?(Array) && associated_type.any?
        associated_type.first.to_sym
      else
        field
      end
    end

    def find_resource_field_from(field)
      resource_manager.attribute_types[field] || resource_manager.field_class_for(resolve_association(field))
    end
  end
end
