module Krudmin
  module Presenters
    class BelongsToFieldPresenter < BaseFieldPresenter
      delegate :associated_options, :collection_label_field, :association_name, to: :field

      def render_form
        render_partial(:form, association_name: association_name, associated_options: associated_options, collection_label_field: collection_label_field)
      end

      def render_search
        render_partial(:search, search_form: search_form, association_name: association_name, associated_options: associated_options, collection_label_field: collection_label_field, search_value: search_value, options_attribute: options_attribute)
      end
    end
  end
end
