module Krudmin
  class ApplicationController < Krudmin::Config.parent_controller.constantize
    include Krudmin::KrudminControllerSupport
    include Krudmin::ModelStatusToggler
    include Krudmin::CrudMessages
    include Krudmin::Searchable

    before_action :set_model, only: [:new, :edit, :create]

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

    def page
      params.fetch(:page, 0)
    end

    def limit
      params.fetch(:limit, 25)
    end

    private

    def set_model
      @model = model
    end

    def authorize_model(model)
      model
    end
  end
end
