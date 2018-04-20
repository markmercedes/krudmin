module Krudmin
  module MutationHandlers
    class ModalFormContextUpdate < SimpleDelegator
      attr_reader :model, :success_message
      def initialize(controller, model, success_message)
        @model = model
        @success_message = success_message

        super(controller)
      end

      def successful_html_response(format)
        format.html do
          flash[:info] = [success_message]

          redirect_to edit_resource_path(model)
        end
      end

      def successful_js_response(format)
        format.js do
          instance_variable_set(:@model_id, model.id)

          render "edit", locals: { messages: [ActionResultMessage.new("info", success_message)] }
        end
      end

      def perform
        respond_to do |format|
          successful_html_response(format)

          successful_js_response(format)
        end
      end

      def self.call(controller, model, success_message)
        new(controller, model, success_message).perform
      end
    end
  end
end
