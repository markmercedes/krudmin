module Krudmin
  module Presenters
    class DateTimeFieldPresenter < BaseFieldPresenter
      def render_search
        search_options = [
          {
            options: "#{attribute}__from_options",
            field: "#{attribute}__from",
            filter: :gteq
          },
          {
            options: "#{attribute}__to_options",
            field: "#{attribute}__to",
            filter: :lteq
          },
        ]

        render_partial(:search, search_form: search_form, search_options: search_options)
      end
    end
  end
end
