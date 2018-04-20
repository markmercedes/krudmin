module Krudmin
  class ListActionPanel
    attr_reader :model, :actions, :view_context, :remote

    def initialize(model, actions, view_context, remote: false)
      @model = model
      @actions = actions
      @view_context = view_context
      @remote = remote
    end

    def self.for(model, actions, view_context, remote: false)
      new(model, actions, view_context, remote: remote)
    end

    def to_s
      (actions.map do |action|
        action_button(action).to_s
      end).join.html_safe
    end

    def action_button(button_type)
      "Krudmin::ActionButtons::#{button_type.to_s.classify}Button".constantize.new(:list, view_context, model, remote: remote)
    end
  end
end
