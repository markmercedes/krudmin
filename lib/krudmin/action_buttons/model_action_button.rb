module Krudmin
  module ActionButtons
    class ModelActionButton < Base
      attr_reader :page, :view_context, :model, :html_options, :button_body
      def initialize(page, view_context, model, html_options = {}, &block)
        @model = model

        super(page, view_context, "#", html_options, &block)
      end

      def default_locals
        { model: model }.merge(super)
      end

      def model_label
        view_context.krudmin_manager.model_label(model)
      end
    end
  end
end
