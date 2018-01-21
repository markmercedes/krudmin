module Krudmin
  module ActionButtons
    class Base

      VIEW_PATH = :application

      attr_reader :page, :view_context, :action_path, :html_options, :button_body
      def initialize(page, view_context, action_path = '#', html_options = {}, &block)
        @page, @view_context, @action_path, @html_options, @button_body = page, view_context, action_path, html_options, block
      end

      def to_s
        send("render_#{page}")
      end

      def render_partial(partial_name, locals = {})
        view_context.render(partial: "#{partial_path}/#{partial_name}", locals: default_locals.merge(locals))
      end

      def partial_path
        "krudmin/#{self.class::VIEW_PATH}/action_buttons/#{partial_scope}"
      end

      def partial_scope
        @partial_scope ||= self.class.name.demodulize.split('Field').first.underscore
      end

      def default_locals
        {html_options: html_options, action_path: action_path}
      end
    end
  end
end
