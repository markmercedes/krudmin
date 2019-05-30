module Krudmin
  module ActionButtons
    class Base
      attr_reader :page, :view_context, :action_path, :html_options, :button_body
      def initialize(page, view_context, action_path = "#", html_options = {}, &block)
        @page = page
        @view_context = view_context
        @action_path = action_path
        @html_options = html_options
        @button_body = block
      end

      def to_s
        send("render_#{page}")
      end

      def render_partial(partial_name, locals = {})
        if button_body
          view_context.render(layout: "#{partial_path}/#{partial_name}", locals: default_locals.merge(locals), &button_body)
        else
          view_context.render(partial: "#{partial_path}/#{partial_name}", locals: default_locals.merge(locals))
        end
      end

      def partial_path
        "#{Krudmin::Config.theme}/action_buttons/#{partial_scope}"
      end

      def partial_scope
        @partial_scope ||= self.class.name.demodulize.split("Field").first.underscore
      end

      def default_locals
        { html_options: tooltip_options.merge(html_options), action_path: action_path }
      end

      def tooltip_options
        {"data-toggle"=>"tooltip", "title"=> tooltip_title, "data-placement"=> tooltip_position }
      end

      def tooltip_title; end
      def tooltip_position; end

      def render_list
        render_partial(:list)
      end

      def render_form
        render_partial(:form)
      end
    end
  end
end
