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

      if model.save
        redirect_to edit_resource_path(model), notice: created_message
      else
        render "new"
      end
    end

    def update
      model.update_attributes(model_params)

      if model.valid?
        redirect_to edit_resource_path(model), notice: modified_message
      else
        render "edit"
      end
    end

    def destroy
      if model.destroy
        redirect_to resource_root, notice: destroyed_message
      else
        redirect_to edit_resource_path(model, failed_destroy: 1), notice: cant_be_destroyed_message
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
