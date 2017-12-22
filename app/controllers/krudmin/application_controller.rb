module Krudmin
  class ApplicationController < ActionController::Base
    include Admin::CrudMessages

    before_action :set_model, only: [:new, :edit, :create]

    helper_method :items, :resource_label, :resources_label, :model_label, :resource_root, :resource_path, :list_actions, :listable_columns, :edit_resource_path, :default_view_path, :resource, :activate_path, :deactivate_path, :crud_title, :model, :editable_attributes, :model_id, :new_resource_path, :form_submit_path, :resource_path, :edit_resource_path

    delegate :scope, :items, :activate_path, :deactivate_path, :list_actions, :listable_columns, :resource_root, :resource_label, :resources_label, :resource, :model_id, :editable_attributes, :new_resource_path, :resource_path, :edit_resource_path, to: :krudmin_manager

    DEFAULT_VIEW_PATH = 'krudmin'.freeze

    def krudmin_manager
      @krudmin_manager ||= self.class::GATEWAY.new(self)
    end

    def default_view_path
      DEFAULT_VIEW_PATH
    end

    def index
      render template: "#{DEFAULT_VIEW_PATH}/index"
    end

    def edit
      model.destroy if params.fetch(:failed_destroy, false)
      render template: "#{DEFAULT_VIEW_PATH}/edit"
    end

    def show
      raise NotImplementedError
      # render template: "#{DEFAULT_VIEW_PATH}/new"
    end

    def new
      render template: "#{DEFAULT_VIEW_PATH}/new"
    end

    def create
      model.attributes = model_params

      respond_to do |format|
        if model.save
          format.html { redirect_to edit_resource_path(model), notice: created_message }
        else
          format.html {
            render template: "#{DEFAULT_VIEW_PATH}/new"
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
            render template: "#{DEFAULT_VIEW_PATH}/edit"
          }
        end
      end
    end

    def activate
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
      @model_label ||= krudmin_manager.model_label
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

    def model_params
      @model_params ||= params.require(resource.name.underscore.downcase.to_sym).permit(krudmin_manager.permitted_attributes)
    end

    def form_submit_path
      model.new_record? ? resource_root : resource_path(model)
    end
  end
end
