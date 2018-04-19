module Krudmin
  class ApplicationController < Krudmin::Config.parent_controller.constantize
    include Krudmin::KrudminControllerSupport
    include Krudmin::KrudminResourceManagerControllerSupport
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

      ModelMutation.(self, model, created_message)
    end

    class ActionResultMessage < Struct.new(:type, :text); end

    class FormContextValidUpdate
      attr_reader :controller, :model, :success_message
      def initialize(controller, model, success_message)
        @controller = controller
        @model = model
        @success_message = success_message
      end

      def successful_html_response(format)
        format.html do
          controller.flash[:info] = [success_message]

          controller.redirect_to controller.edit_resource_path(model)
        end
      end

      def successful_js_response(format)
        format.js do
          controller.instance_variable_set(:@model_id, model.id)

          controller.render "edit", locals: { messages: [ActionResultMessage.new("info", success_message)] }
        end
      end

      def perform
        controller.respond_to do |format|
          successful_html_response(format)

          successful_js_response(format)
        end
      end

      def self.call(controller, model, success_message)
        new(controller, model, success_message).perform
      end
    end

    class RegularContexValidtUpdate
      attr_reader :controller, :model, :success_message
      def initialize(controller, model, success_message)
        @controller = controller
        @model = model
        @success_message = success_message
      end

      def perform
        controller.flash[:info] = [success_message]
        controller.redirect_to controller.edit_resource_path(model)
      end

      def self.call(controller, model, success_message)
        new(controller, model, success_message).perform
      end
    end

    class ModelMutation
      attr_reader :controller, :model, :success_message, :new_record
      def initialize(controller, model, success_message)
        @controller = controller
        @model = model
        @success_message = success_message
        @new_record = model.new_record?
      end

      def self.call(controller, model, success_message)
        new(controller, model, success_message).perform
      end

      def perform
        valid? ? valid_path : invalid_path
      end

      private

      def on_error_view
        new_record ? "new" : "edit"
      end

      def valid?
        model.save
      end

      def valid_path
        valid_context_mutator.(controller, model, success_message)
      end

      def valid_context_mutator
        controller.modal_form_context? ? FormContextValidUpdate : RegularContexValidtUpdate
      end

      def invalid_path
        controller.respond_to do |format|
          format.html { controller.render on_error_view }
          format.js { render "form_errors" }
        end
      end
    end

    def update
      model.attributes = model_params

      ModelMutation.(self, model, modified_message)
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
