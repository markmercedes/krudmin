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

        associated_type = resource_manager.send(:resource_attributes).find_type_for(field)

        if associated_type.respond_to?(:first)
          associated_type = associated_type.first&.to_sym
        else
          associated_type = field
        end

        hash[field] = resource_manager.field_class_for(associated_type).parse_with_field(params[field])

        hash
      end
    end
  end
end
