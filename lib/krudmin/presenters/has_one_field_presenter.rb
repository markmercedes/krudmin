module Krudmin
  module Presenters
    class HasOneFieldPresenter < BaseFieldPresenter
      def render_form
        render_partial(partial_form, options: options, render_partial: method(:render_partial))
      end
    end
  end
end
