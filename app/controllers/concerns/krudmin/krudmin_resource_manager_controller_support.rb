module Krudmin
  module KrudminResourceManagerControllerSupport
    extend ActiveSupport::Concern

    included do
      delegate :permitted_attributes, :resource_label, :resources_label, :scope, :listable_actions, :listable_attributes, :model_class, :editable_attributes, to: :krudmin_manager
      delegate :grouped_attributes, :resource_instance_label_attribute, :searchable_attributes, :displayable_attributes, :field_for, to: :krudmin_manager

      helper_method :resource_label, :resources_label, :items, :model_label, :resource_root, :listable_actions, :listable_attributes, :model_class, :model, :editable_attributes
      helper_method :krudmin_manager, :field_for, :grouped_attributes, :resource_instance_label_attribute, :searchable_attributes, :displayable_attributes

      delegate :resource_root, :activate_path, :deactivate_path, :new_resource_path, :resource_path, :edit_resource_path, to: :krudmin_router

      helper_method :resource_root, :activate_path, :deactivate_path, :new_resource_path, :resource_path, :edit_resource_path, :form_submit_path

      Krudmin::ResourceManagers::Routing::DEFINED_ACTION_METHODS.each do |action_name|
        defined_method = "#{action_name}_route?".to_sym

        delegate defined_method, to: :krudmin_router
        helper_method defined_method

        defined_access_method = "#{action_name}_access?"

        helper_method defined_access_method

        define_method(defined_access_method) do |*args|
          defined?(super) ? super(*args) && method(defined_method).call : method(defined_method).call
        end
      end
    end

    def model
      @model ||= model_id ? scope.find(model_id) : scope.all.build(default_model_attributes)
    end

    def default_model_attributes
      {}
    end

    def model_params
      @model_params ||= Krudmin::ParamsParser.new(permitted_params, model_class).to_h.permit!
    end

    def permitted_params
      params.require(model_class.name.underscore.downcase.to_sym).permit(permitted_attributes)
    end

    def form_submit_path(*params)
      model.new_record? ? resource_root(*params) : resource_path(model, *params)
    end

    def model_label
      @model_label ||= krudmin_manager.model_label(model)
    end

    def items
      @items ||= item_list.ransack(search_form.params)
    end

    def krudmin_manager
      @krudmin_manager ||= resource_manager.new
    end

    def resource_manager
      inferred_resource_manager
    end

    def inferred_resource_manager
      @inferred_resource_manager ||= "#{self.class.name.demodulize.gsub('Controller', '')}ResourceManager".constantize
    end

    def item_list
      krudmin_manager.items.page(page).per(limit)
    end
  end
end
