module Krudmin
  module Searchable
    extend ActiveSupport::Concern

    included do
      helper_method :search_form
    end

    def search_form_params
      @search_form_params ||=  PersistedSearchResults.new(params.fetch(:q, {}).permit!, default_search_params, controller_path, cookies).to_h
    end

    def default_search_params
      {}
    end

    def search_form
      @search_form ||= Krudmin::SearchForm.new(searchable_attributes, model_class, search_by: search_form_params, order_by: sort_by_criteria)
    end

    def sort_by_criteria
      search_form_params[:s] || krudmin_manager.order_by
    end

    class PersistedSearchResults
      module CookieSerializer
        private

        def serialize(value)
          JSON.generate(value)
        end

        def deserialize(value)
          JSON.parse(value)
        end
      end

      include CookieSerializer

      CACHE_NODE = "krudmin_search_results".freeze

      delegate :[], :include?, to: :to_h

      attr_reader :params, :default_params, :cache_path, :cache_adapter
      def initialize(params, default_params, cache_path, cache_adapter)
        @params = params
        @default_params = default_params
        @cache_path = cache_path
        @cache_adapter = cache_adapter
      end

      def reset_cache?
        params[:reset_search].present?
      end

      def to_h
        @to_h ||= HashWithIndifferentAccess.new(values)
      end

      private

      def global_search
        @global_search ||= deserialize(cache_adapter.fetch(CACHE_NODE, "{}"))
      end

      def cached_params
        @cached_params ||= global_search[cache_path]
      end

      def values
        @values ||= begin
          global_search[cache_path] = if params.empty?
            cached_params.blank? ? default_params : cached_params
          else
            params.to_h
          end

          cache_adapter[CACHE_NODE] = serialize(global_search)

          global_search[cache_path]
        end
      end
    end
  end
end
