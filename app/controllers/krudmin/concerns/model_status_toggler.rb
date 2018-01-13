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
      respond_to do |format|
        if model.send(status_method)
          format.html { redirect_to resource_root, notice: model_status_messages[status_method][:on_success] }
        else
          format.js { redirect_to edit_resource_path(model), notice: model_status_messages[status_method][:on_error] }
          format.html { redirect_to edit_resource_path(model), notice: model_status_messages[status_method][:on_error] }
        end
      end
    end
  end
end