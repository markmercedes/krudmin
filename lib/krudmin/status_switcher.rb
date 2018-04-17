module Krudmin
  class StatusSwitcher
    OperationResultWithMessage = Struct.new(:message, :type, :triggered_action)
    MODEL_ON_METHOD = :activate!
    MODEL_OFF_METHOD = :deactivate!
    DEFAULT_CONTEXT = :list

    attr_reader :controller, :context, :model, :model_label
    def initialize(controller, model, model_label, context: DEFAULT_CONTEXT)
      @controller = controller
      @context = context || DEFAULT_CONTEXT
      @model = model
      @model_label = model_label
    end

    def cant_be_turned_on_message
      I18n.t("krudmin.messages.cant_be_activated", label: model_label)
    end

    def cant_be_turned_off_message
      I18n.t("krudmin.messages.cant_be_deactivated", label: model_label)
    end

    def turned_on_message
      I18n.t("krudmin.messages.activated", label: model_label)
    end

    def turned_off_message
      I18n.t("krudmin.messages.deactivated", label: model_label)
    end

    def call(new_state)
      result = send("switch_#{new_state}")

      send("handle_#{context}_context", result)
    end

    def partial_name
      status_method.to_s.gsub("!", "")
    end

    def handle_show_context
      controller.flash[result.type] = with_model_error_messages(result)

      controller.redirect_to controller.resource_path(model)
    end

    def list_error_response(result)
      controller.respond_to do |format|
        format.html do
          controller.flash[result.type] = result.message
          controller.redirect_back(fallback_location: controller.resource_root)
        end

        format.js { controller.render partial: "js_error_messages", locals: { error_messages: with_model_error_messages(result) } }
      end
    end

    def list_successful_response(result)
      controller.respond_to do |format|
        format.html do
          controller.flash[result.type] = result.message
          controller.redirect_to controller.resource_root
        end

        format.js { controller.render result.triggered_action.to_s }
      end
    end

    def handle_list_context(result)
      if result.type == :error
        list_error_response(result)
      else
        list_successful_response(result)
      end
    end

    def handle_form_context(result)
      controller.flash[result.type] = with_model_error_messages(result)

      controller.redirect_to controller.edit_resource_path(model)
    end

    private

    def switch_on
      if model.send(self.class::MODEL_ON_METHOD)
        OperationResultWithMessage.new(turned_on_message, :success, :activate)
      else
        OperationResultWithMessage.new(cant_be_turned_on_message, :error, :activate)
      end
    end

    def switch_off
      if model.send(self.class::MODEL_OFF_METHOD)
        OperationResultWithMessage.new(turned_off_message, :warning, :deactivate)
      else
        OperationResultWithMessage.new(cant_be_turned_off_message, :error, :deactivate)
      end
    end

    def with_model_error_messages(result)
      [result.message].concat(model.errors.full_messages)
    end
  end
end
