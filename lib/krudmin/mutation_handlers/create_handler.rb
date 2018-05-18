module Krudmin
  module MutationHandlers
    class CreateHandler
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

      def on_error_view
        "new"
      end

      private

      def valid?
        model.save
      end

      def valid_path
        valid_context_mutator.(controller, model, success_message)
      end

      def valid_context_mutator
        controller.modal_form_context? ? ModalFormContextUpdate : FormContextUpdate
      end

      def invalid_path
        controller.respond_to do |format|
          format.html { controller.render on_error_view }
          format.js { controller.render "form_errors" }
        end
      end
    end
  end
end
