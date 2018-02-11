module Krudmin
  class ParamsParser

    attr_reader :params, :model_klass
    def initialize(params, model_klass)
      @params = params
      @model_klass = model_klass
    end

    def to_h
      params.to_h.inject(params.class.new) do |hash, item|
        field = item.first
        value = item.last
        column = model_klass.columns_hash[field]

        if column && value.present?
          hash[field] = case column.type
            when :datetime
              DateTime.strptime(value, I18n.t("krudmin.datetime.input_format"))
            when :date
              DateTime.strptime(value, I18n.t("krudmin.date.input_format"))
            else value
          end
        else
          hash[field]
        end

        hash
      end
    end
  end
end
