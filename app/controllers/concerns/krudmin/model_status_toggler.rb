module Krudmin
  module ModelStatusToggler
    def activate
      switch_status(:on)
    end

    def deactivate
      switch_status(:off)
    end

    private

    def switch_status(new_status)
      Krudmin::StatusSwitcher.new(self, model, model_label, context: params[:context]).call(new_status)
    end
  end
end
