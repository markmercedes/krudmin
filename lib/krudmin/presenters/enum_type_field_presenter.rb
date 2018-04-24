module Krudmin
  module Presenters
    class EnumTypeFieldPresenter < BelongsToFieldPresenter
      delegate :associated_options, :enum_value, :humanize_value, to: :field

      def render_json
        super.merge(value: enum_value)
      end

      def render_form
        render_partial(:form, associated_options: associated_options, enum_value: enum_value)
      end

      def render_show
        render_partial(:show, humanize_value: humanize_value)
      end

      def associated_resource_manager_class
        nil
      end

      def standarized_associated_options
        associated_options.map do |option|
          {
            id: option.last,
            label: option.first,
          }
        end
      end
    end
  end
end
