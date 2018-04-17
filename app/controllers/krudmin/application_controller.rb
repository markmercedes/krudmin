module Krudmin
  class ApplicationController < Krudmin::Config.parent_controller.constantize
    include Krudmin::KrudminControllerSupport
    include Krudmin::Authorizable
    include Krudmin::ModelStatusToggler
    include Krudmin::CrudMessages
    include Krudmin::Searchable
    include Krudmin::ActionButtonsSupport
    include Krudmin::HelperIncluder

    layout Krudmin::Config.layout

    before_action :set_view_path
    before_action :set_model, only: [:new, :edit, :create]

    def index; end

    def edit
      model.destroy if params.fetch(:failed_destroy, false)
    end

    def show; end

    def new; end

    def create
      model.attributes = model_params

      authorize_model(model)

      if model.save
        flash[:success] = created_message
        redirect_to edit_resource_path(model)
      else
        respond_to do |format|
          format.html { render "new" }
          format.js { render "form_errors" }
        end
      end
    end

    def update
      model.update_attributes(model_params)

      if model.valid?
        flash[:success] = [modified_message].concat(*model.errors.full_messages)
        redirect_to edit_resource_path(model)
      else
        respond_to do |format|
          format.html { render "edit" }
          format.js { render "form_errors" }
        end
      end
    end

    def destroy
      if model.destroy
        respond_to do |format|
          format.html do
            flash[:error] = destroyed_message
            redirect_to resource_root
          end

          format.js { render "destroy" }
        end
      else
        flash[:error] = cant_be_destroyed_message
        redirect_to edit_resource_path(model, failed_destroy: 1)
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

    def authorize_model(model = nil)
      model
    end

    def set_view_path
      lookup_context.prefixes.append Krudmin::Config.theme
    end
  end
end
