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

    def form_context
      params[:form_context]
    end

    def modal_form_context?
      form_context == "modal"
    end

    def create
      model.attributes = model_params

      authorize_model(model)

      if model.save
        if modal_form_context?
          respond_to do |format|
            format.html do
              flash[:info] = created_message

              redirect_to edit_resource_path(model)
            end

            format.js do
              params[:id] = model.id # This is something dirty I'm not exactly proud of

              render "edit", locals: { messages: [OpenStruct.new(type: "info", text: created_message)] }
            end
          end
        else
          flash[:info] = created_message

          redirect_to edit_resource_path(model)
        end
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
        if modal_form_context?
          respond_to do |format|
            format.html do
              flash[:info] = [modified_message]

              redirect_to edit_resource_path(model)
            end

            format.js do
              render "edit", locals: { messages: [OpenStruct.new(type: "info", text: modified_message)] }
            end
          end
        else
          flash[:info] = [modified_message]

          redirect_to edit_resource_path(model)
        end
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
