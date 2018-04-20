module Krudmin
  module MutationHandlers
    class FormContextUpdate < SimpleDelegator
      attr_reader :controller, :model, :success_message
      def initialize(controller, model, success_message)
        @model = model
        @success_message = success_message

        super(controller)
      end

      def perform
        flash[:info] = [success_message]

        redirect_to edit_resource_path(model)
      end

      def self.call(controller, model, success_message)
        new(controller, model, success_message).perform
      end
    end
  end
end
