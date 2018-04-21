module Krudmin
  class ActionDispatcher < SimpleDelegator
    attr_reader :message, :flash_type

    def initialize(controller, message, flash_type)
      @message = message
      @flash_type = flash_type

      super(controller)
    end

    def dispatch
      respond_to do |format|
        html_response(format)

        js_response(format)

        json_response(format)
      end
    end

    private

    def html_response(format); end

    def js_response(format); end

    def json_response(format); end
  end
end
