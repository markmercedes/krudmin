module Krudmin
  module MutationHandlers
    class SwitchOnHandler < SimpleDelegator
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

      def valid_path
        valid_context_dispatcher.new(self, success_message).dispatch
      end

      def invalid_path
        invalid_context_dispatcher.new(self, failure_message).dispatch
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

      class ValidListContext < SimpleDelegator
        attr_reader :message

        def initialize(controller, message)
          @message = message

          super(controller)
        end

        def dispatch
          respond_to do |format|
            successful_html_response(format)

            successful_js_response(format)
          end
        end

        def successful_html_response(format)
          format.html do
            flash[:success] = message

            redirect_to resource_root
          end
        end

        def successful_js_response(format)
          format.js { render command.to_s }
        end
      end

      class InvalidListContext < SimpleDelegator
        attr_reader :message

        def initialize(controller, message)
          @message = message

          super(controller)
        end

        def unsuccessful_html_response(format)
          format.html do
            flash[:error] = message

            redirect_to resource_root
          end
        end

        def unsuccessful_js_response(format)
          format.js { render partial: "js_error_messages", locals: { error_messages: [message] } }
        end

        def dispatch
          respond_to do |format|
            unsuccessful_html_response(format)

            unsuccessful_js_response(format)
          end
        end
      end

      class ValidFormContext < SimpleDelegator
        attr_reader :message
        FLASH_TYPE = :success

        def initialize(controller, message)
          @message = message

          super(controller)
        end

        def dispatch
          flash[self.class::FLASH_TYPE] = [message]

          redirect_to edit_resource_path(model)
        end
      end

      class InvalidFormContext < ValidFormContext
        FLASH_TYPE = :error
      end

      def self.call(controller, command, success_message, failure_message)
        new(controller, command, success_message, failure_message).perform
      end
    end
  end
end
