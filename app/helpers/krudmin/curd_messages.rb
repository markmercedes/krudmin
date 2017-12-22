module Krudmin
  module CrudMessages
    def created_message_for(label)
      I18n.t('krudmin.messages.created', label: label)
    end

    def modified_message_for(label)
      I18n.t('krudmin.messages.modified', label: label)
    end

    def cant_be_created_message_for(label)
      I18n.t('krudmin.messages.cant_be_created', label: label)
    end

    def cant_be_modified_message_for(label)
      I18n.t('krudmin.messages.cant_be_modified', label: label)
    end

    def cant_be_activated_message_for(label)
      I18n.t('krudmin.messages.cant_be_activated', label: label)
    end

    def cant_be_deactivated_message_for(label)
      I18n.t('krudmin.messages.cant_be_deactivated', label: label)
    end

    def activated_message_for(label)
      I18n.t('krudmin.messages.activated', label: label)
    end

    def deactivated_message_for(label)
      I18n.t('krudmin.messages.deactivated', label: label)
    end

    def destroyed_message_for(label)
      I18n.t('krudmin.messages.destroyed', label: label)
    end

    def cant_be_destroyed_message_for(label)
      I18n.t('krudmin.messages.cant_be_destroyed', label: label)
    end

    def confirm_destroy_message(given_model)
      I18n.t('krudmin.messages.confirm_destroy', label: krudmin_manager.model_label(given_model))
    end

    def confirm_activation_message(given_model)
      I18n.t('krudmin.messages.confirm_activation', label: krudmin_manager.model_label(given_model))
    end

    def confirm_deactivation_message(given_model)
      I18n.t('krudmin.messages.confirm_deactivation', label: krudmin_manager.model_label(given_model))
    end

    def edit_title
      I18n.t('krudmin.messages.edit_record', label: model_label)
    end

    def new_title
      I18n.t('krudmin.messages.new_record', label: resource_label)
    end

    def created_message
      created_message_for(model_label)
    end

    def modified_message
      modified_message_for(model_label)
    end

    def cant_be_created_message
      cant_be_created_message_for(model_label)
    end

    def cant_be_modified_message
      cant_be_modified_message_for(model_label)
    end

    def cant_be_activated_message
      cant_be_activated_message_for(model_label)
    end

    def cant_be_deactivated_message
      cant_be_deactivated_message_for(model_label)
    end

    def activated_message
      activated_message_for(model_label)
    end

    def deactivated_message
      deactivated_message_for(model_label)
    end

    def destroyed_message
      destroyed_message_for(model_label)
    end

    def cant_be_destroyed_message
      cant_be_destroyed_message_for(model_label)
    end

    def crud_title
      model.new_record? ? new_title : edit_title
    end
  end
end
