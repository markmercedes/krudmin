module Krudmin
  module MutationHandlers
    class SwitchOnHandler < SimpleDelegator
      SUCCESS_FLASH_TYPE = :success
      FAILURE_FLASH_TYPE = :error

      attr_reader :command, :success_message, :failure_message
      def initialize(controller, command, success_message, failure_message)
        @command = command
        @success_message = success_message
        @failure_message = failure_message

        super(controller)
      end

      def valid?
        model.send("#{command}!")
      end

      def perform
        valid? ? valid_path : invalid_path
      end

      def self.call(controller, command, success_message, failure_message)
        new(controller, command, success_message, failure_message).perform
      end

      private

      def valid_path
        valid_context_dispatcher.new(self, success_message, self.class::SUCCESS_FLASH_TYPE).dispatch
      end

      def invalid_path
        invalid_context_dispatcher.new(self, failure_message, self.class::FAILURE_FLASH_TYPE).dispatch
      end

      def model_context
        params[:context]
      end

      def valid_context_dispatcher
        case model_context
        when "form" then ValidFormContext
        else ValidListContext
        end
      end

      def invalid_context_dispatcher
        case model_context
        when "form" then InvalidFormContext
        else InvalidListContext
        end
      end

      class ValidListContext < Krudmin::ActionDispatcher
        private

        def html_response(format)
          format.html do
            flash[flash_type] = message

            redirect_to resource_root
          end
        end

        def js_response(format)
          format.js { render command.to_s }
        end
      end

      class InvalidListContext < ValidListContext
        private

        def js_response(format)
          format.js { render partial: "js_error_messages", locals: { error_messages: [message] } }
        end
      end

      class ValidFormContext < Krudmin::ActionDispatcher
        def dispatch
          flash[flash_type] = [message]

          redirect_to edit_resource_path(model)
        end
      end

      class InvalidFormContext < ValidFormContext; end
    end
  end
end
