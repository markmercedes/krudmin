module Krudmin
  module Fields
    class DateTime < Base
      SEARCH_PREDICATES = [:eq, :not_eq, :lt, :lteq, :gt, :gteq]
      DEFAULT_VALUE = '-'

      def date
        I18n.localize(
          data.in_time_zone(timezone).to_date,
          format: format,
        ) if data
      end

      def datetime
        I18n.localize(
          data.in_time_zone(timezone),
          format: format,
          default: data,
        ) if data
      end

      def to_s
        case value
        when ::DateTime
          datetime
        when ::Date
          date
        else
          datetime
        end || default_value
      end

      def format
        options.fetch(:format, :default)
      end

      def timezone
        options.fetch(:timezone, "UTC")
      end

      def render_search(page, h, options)
        form = options.fetch(:form)
        _attribute = attribute

        Arbre::Context.new do
          div(class: "col-sm-6") do
            ul(class: "list-unstyled") do
              li form.hidden_field "#{_attribute}__from_options", value: :gteq
              li form.date_field "#{_attribute}__from", required: false, class: "form-control"
            end
          end

          div(class: "col-sm-6") do
            ul(class: "list-unstyled") do
              li form.hidden_field "#{_attribute}__to_options", value: :gteq
              li form.date_field "#{_attribute}__to", required: false, class: "form-control"
            end
          end
        end
      end

      def self.search_config_for(field)
        ["#{field}__from".to_sym, "#{field}__to".to_sym]
      end

      def self.search_criteria_for(key, _value)
        value = Date.parse(_value)

        if key.to_s.end_with?("__to")
          value.end_of_day
        else
          value.beginning_of_day
        end
      end

      private

      def default_value
        options.fetch(:default_value, DEFAULT_VALUE)
      end
    end
  end
end
