module Krudmin
  module ModelStatusToggler
    def activate
      toggle_model_status(:activate!)
    end

    def deactivate
      toggle_model_status(:deactivate!)
    end

    private

    def model_status_messages
      @model_status_messages ||= {
        activate!: {on_success: activated_message, on_error: cant_be_activated_message},
        deactivate!: {on_success: deactivated_message, on_error: cant_be_deactivated_message}
      }
    end

    def toggle_model_status(status_method)
      message_node = model_status_messages[status_method]

      if model.send(status_method)
        redirect_to resource_root, notice: message_node[:on_success]
      else
        redirect_to edit_resource_path(model), notice: message_node[:on_error]
      end
    end
  end
end