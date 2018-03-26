module Krudmin
  module KrudminControllerSupport
    extend ActiveSupport::Concern

    included do
      delegate :permitted_attributes, :resource_label, :resources_label, :scope, :listable_actions, :listable_attributes, :model_class, :editable_attributes, to: :krudmin_manager
      delegate :grouped_attributes, :resource_instance_label_attribute, :searchable_attributes, :displayable_attributes, :field_for, to: :krudmin_manager

      helper_method :resource_label, :resources_label, :items, :model_label, :resource_root, :listable_actions, :listable_attributes, :model_class, :model, :editable_attributes
      helper_method :model_id, :krudmin_manager, :field_for, :grouped_attributes, :resource_instance_label_attribute, :searchable_attributes, :displayable_attributes

      delegate :resource_root, :activate_path, :deactivate_path, :new_resource_path, :resource_path, :edit_resource_path, to: :krudmin_router

      helper_method :resource_root, :activate_path, :deactivate_path, :new_resource_path, :resource_path, :edit_resource_path

      helper_method :form_submit_path, :navigation_menu, :_current_user, :krudmin_root_path

      Krudmin::ResourceManagers::Routing::DEFINED_ACTION_METHODS.each do |action_name|
        defined_method = "#{action_name}_route?".to_sym

        delegate defined_method, to: :krudmin_router
        helper_method defined_method
      end
    end

    def model_id
      params[:id]
    end

    def model
      @model ||= model_id ? scope.find(model_id) : scope.all.build(default_model_attributes)
    end

    def default_model_attributes
      {}
    end

    def model_params
      @model_params ||= Krudmin::ParamsParser.new(permitted_params, model.class).to_h.permit!
    end

    def permitted_params
      params.require(model_class.name.underscore.downcase.to_sym).permit(permitted_attributes)
    end

    def form_submit_path
      model.new_record? ? resource_root : resource_path(model)
    end

    def model_label
      @model_label ||= krudmin_manager.model_label(model)
    end

    def krudmin_router
      @krudmin_router ||= Krudmin::ResourceManagers::Routing.from(AppRouter.new(Rails.application.routes), krudmin_routing_path)
    end

    def krudmin_routing_path
      controller_path
    end

    def items
      @items ||= item_list.ransack(search_form.params)
    end

    def krudmin_manager
      @krudmin_manager ||= resource_manager.new
    end

    def _current_user
      instance_eval(&Krudmin::Config.current_user_method)
    end

    def krudmin_root_path
      @krudmin_root_path ||= Rails.application.routes.url_helpers.send(Krudmin::Config.krudmin_root_path)
    end

    def navigation_menu
      @navigation_menu ||= Krudmin::Config.navigation_menu.for(_current_user)
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
