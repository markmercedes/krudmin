module Krudmin
  class ApplicationController < Krudmin::Config.parent_controller.constantize
    include Krudmin::CrudMessages
    include Krudmin::ModelStatusToggler

    before_action :set_model, only: [:new, :edit, :create]

    helper_method :resource_label, :resources_label, :items, :model_label, :resource_root, :resource_path, :listable_actions, :listable_attributes, :edit_resource_path, :model_class, :activate_path, :deactivate_path, :crud_title, :model, :editable_attributes, :model_id, :new_resource_path, :form_submit_path, :resource_path, :edit_resource_path, :confirm_deactivation_message, :confirm_activation_message, :confirm_destroy_message, :menu_items, :_current_user, :krudmin_root_path, :resource_instance_label_attribute, :search_form, :searchable_attributes, :krudmin_manager, :field_for, :grouped_attributes

    delegate :resource_label, :resources_label, :scope, :listable_actions, :listable_attributes, :resource_root, :model_class, :model_id, :editable_attributes, :grouped_attributes, :resource_instance_label_attribute, :searchable_attributes, :field_for, to: :krudmin_manager

    delegate :activate_path, :deactivate_path, :new_resource_path, :resource_path, :edit_resource_path, :resource_root, to: :krudmin_router

    def search_form_params
      params.include?(:q) ? params.require(:q).permit! : default_search_params
    end

    def default_search_params
      {}
    end

    def search_form
      @search_form ||= Krudmin::SearchForm.new(searchable_attributes, model_class, search_by: search_form_params, order_by: sort_by_criteria)
    end

    def sort_by_criteria
      search_form_params[:s] || krudmin_manager.order_by
    end

    def _current_user
      instance_eval(&Krudmin::Config.current_user_method)
    end

    def krudmin_root_path
      @krudmin_root_path ||= Rails.application.routes.url_helpers.send(Krudmin::Config.krudmin_root_path)
    end

    def menu_items
      @menu_items ||= Krudmin::NavigationItems.new(user: _current_user)
    end

    def krudmin_router
      @krudmin_router ||= Krudmin::ResourceManagers::Routing.from(controller_path)
    end

    def items
      @items ||= item_list.ransack(search_form.params)
    end

    def krudmin_manager
      @krudmin_manager ||= resource_manager.new
    end

    def index
    end

    def edit
      model.destroy if params.fetch(:failed_destroy, false)
    end

    def show
    end

    def new
    end

    def create
      model.attributes = model_params

      authorize_model(model)

      respond_to do |format|
        if model.save
          format.html { redirect_to edit_resource_path(model), notice: created_message }
        else
          format.html {
            render "new"
          }
        end
      end
    end

    def update
      model.update_attributes(model_params)

      respond_to do |format|
        if model.valid?
          format.html {
            redirect_to edit_resource_path(model), notice: modified_message
          }
        else
          format.html {
            render "edit"
          }
        end
      end
    end

    def destroy
      respond_to do |format|
        if model.destroy
          format.html { redirect_to resource_root, notice: destroyed_message }
        else
          format.js { redirect_to edit_resource_path(model, failed_destroy: 1), notice: cant_be_destroyed_message }
          format.html { redirect_to edit_resource_path(model, failed_destroy: 1), notice: cant_be_destroyed_message }
        end
      end
    end

    def model_label
      @model_label ||= krudmin_manager.model_label(model)
    end

    def set_model
      @model = model
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

    def page
      params.fetch(:page, 0)
    end

    def limit
      params.fetch(:limit, 25)
    end

    def model_params
      @model_params ||= params.require(model_class.name.underscore.downcase.to_sym).permit(permitted_attributes)
    end

    def permitted_attributes
      krudmin_manager.permitted_attributes
    end

    def form_submit_path
      model.new_record? ? resource_root : resource_path(model)
    end

    private

    def authorize_model(model)
      model
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
