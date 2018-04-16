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
        activate!: { on_success: activated_message, on_error: cant_be_activated_message },
        deactivate!: { on_success: deactivated_message, on_error: cant_be_deactivated_message },
      }
    end

    def toggle_model_status(status_method)
      message_node = model_status_messages[status_method]
      partial_name = status_method.to_s.gsub("!", "")
      command_result = model.send(status_method)
      action_message = command_result ? message_node[:on_success] : message_node[:on_error]

      if form_context? || !command_result
        display_form_context_after_toggle(action_message)
      else
        status_change_response(action_message, partial_name)
      end
    end

    def form_context?
      params[:context] == "form"
    end

    def display_form_context_after_toggle(action_message)
      redirect_to edit_resource_path(model), notice: action_message
    end

    def status_change_response(action_message, partial_name)
      respond_to do |format|
        format.html { redirect_to resource_root, notice: action_message }
        format.js { render partial_name }
      end
    end
  end
end
