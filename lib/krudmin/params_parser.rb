module Krudmin
  class ParamsParser
    attr_reader :params, :model_klass
    def initialize(params, model_klass)
      @params = params
      @model_klass = model_klass
    end

    def to_h
      params.to_h.reduce(params.class.new) do |hash, item|
        field = item.first

        hash[field] = FieldValueParser.value_for(model_klass.columns_hash[field], item.last)

        hash
      end
    end

    class FieldValueParser
      attr_reader :metadata, :raw_value
      def initialize(metadata, raw_value)
        @metadata = metadata
        @raw_value = raw_value
      end

      def value
        if metadata && raw_value.present?
          case metadata.type
          when :datetime
            parse_time(Time.zone ? Time.zone : Time, raw_value)
          when :date
            Date.strptime(raw_value, I18n.t("krudmin.date.input_format"))
          else raw_value
          end
        else
          raw_value
        end
      end

      def self.value_for(metadata, raw_value)
        new(metadata, raw_value).value
      end

      private

      def parse_time(parser, value)
        parser.strptime(value, I18n.t("krudmin.datetime.input_format"))
      end
    end
  end
end
