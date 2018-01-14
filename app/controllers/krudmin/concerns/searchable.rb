module Krudmin
  module Searchable
    extend ActiveSupport::Concern

    included do
      helper_method :search_form
    end

    def search_form_params
      params.include?(:q) ? params.require(:q).permit! : default_search_params
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
  end
end
