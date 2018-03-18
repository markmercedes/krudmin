require_relative "../presenters/enum_type_field_presenter"

module Krudmin
  module Fields
    class EnumType < BelongsTo
      PRESENTER = Krudmin::Presenters::EnumTypeFieldPresenter

      def enum_value
        @enum_value ||= model.send("#{attribute}_before_type_cast") if model
      end

      def humanize_value
        @enum_text ||= associated_options.key(enum_value) if associated_options.any?
      end

      # TODO: Refactor, infer associated options
      # def associated_options
      #   @associated_options ||= association_predicate.call(associated_class)
      # end

      def associated_options
        options.fetch(:associated_options).call
      end

      def linkable?
        false
      end
    end
  end
end
