module Krudmin
  class ApplicationController < Krudmin::Config.parent_controller.constantize
    include Krudmin::CrudMessages
    include Pundit

    before_action :set_model, only: [:new, :edit, :create]

    helper_method :resource_label, :resources_label, :items, :model_label, :resource_root, :resource_path, :listable_actions, :listable_attributes, :edit_resource_path, :default_view_path, :resource_name, :model_class, :activate_path, :deactivate_path, :crud_title, :model, :editable_attributes, :model_id, :new_resource_path, :form_submit_path, :resource_path, :edit_resource_path, :confirm_deactivation_message, :confirm_activation_message, :confirm_destroy_message, :menu_items, :resources_name, :_current_user, :krudmin_root_path, :resource_instance_label_attribute, :search_form, :searchable_attributes, :krudmin_manager, :field_for, :grouped_attributes

    delegate :resource_label, :resources_label, :scope, :activate_path, :deactivate_path, :listable_actions, :listable_attributes, :resource_root, :resource_name, :model_class, :model_id, :editable_attributes, :grouped_attributes, :new_resource_path, :resource_path, :edit_resource_path, :resources_name, :resource_instance_label_attribute, :searchable_attributes, :field_for, to: :krudmin_manager

    def search_form_params
      params.include?(:q) ? params.require(:q).permit! : default_search_params
    end

    def default_search_params
      {}
    end

    def search_form
      @search_form ||= begin
        _form = Krudmin::SearchForm.new(searchable_attributes, model_class)
        _form.fill_with(search_form_params)
        _form.sort_with(search_form_params[:s] || krudmin_manager.order_by)
        _form
      end
    end

    DEFAULT_VIEW_PATH = 'krudmin/application'.freeze

    def _current_user
      instance_eval(&Krudmin::Config.current_user_method)
    end

    def krudmin_root_path
      @krudmin_root_path ||= Rails.application.routes.url_helpers.send(Krudmin::Config.krudmin_root_path)
    end

    def pundit_user
      _current_user
    end

    def menu_items
      @menu_items ||= Krudmin::NavigationItems.new(user: _current_user)
    end

    def inferred_resource_manager
      "#{self.class.name.demodulize.gsub('Controller', '')}ResourceManager".constantize
    end

    def items
      @items ||= policy_scope(item_list).ransack(search_form.params)
    end

    def item_list
      krudmin_manager.items.page(page).per(limit)
    end

    def resource_manager
      inferred_resource_manager
    end

    def krudmin_manager
      @krudmin_manager ||= resource_manager.new
    end

    def default_view_path
      DEFAULT_VIEW_PATH
    end

    def index
      render "index"
    end

    def edit
      authorize model

      model.destroy if params.fetch(:failed_destroy, false)
      render "edit"
    end

    def show
      authorize model

      render "show"
    end

    def new
      authorize model

      render "new"
    end

    def create
      model.attributes = model_params

      authorize model

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
      authorize model
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

    def activate
      authorize model

      respond_to do |format|
        if model.activate!
          format.html { redirect_to resource_root, notice: activated_message }
        else
          format.js { redirect_to edit_resource_path(model), notice: cant_be_activated_message }
          format.html { redirect_to edit_resource_path(model), notice: cant_be_activated_message }
        end
      end
    end

    def deactivate
      authorize model

      respond_to do |format|
        if model.deactivate!
          format.html { redirect_to resource_root, notice: deactivated_message }
        else
          format.js { redirect_to edit_resource_path(model), notice: cant_be_deactivated_message }
          format.html { redirect_to edit_resource_path(model), notice: cant_be_deactivated_message }
        end
      end
    end

    def destroy
      authorize model

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
      @model ||= model_id ? policy_scope(scope).find(model_id) : scope.all.build(default_model_attributes)
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
  end
end
