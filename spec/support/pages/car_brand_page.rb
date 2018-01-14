require_relative '../page_features'

class CarBrandPage
  include Capybara::DSL
  include FactoryBot::Syntax::Methods
  include PageFeatures

  delegate :description, to: :model

  attr_reader :url, :model
  def initialize(url:, model:)
    @url = url
    @model = model
  end

  def on_index_page?
    has_content?("Manage Car Brands")
  end

  def on_edit_page?
    has_content?("Edit #{description}") && has_field?(:car_brand_description, with: description)
  end

  def has_destroyed_message_visible?
    has_content?("#{description} was successfully destroyed")
  end

  def has_model_visible?
    has_selector?(row_css_for(model))
  end

  def visit_page(page: 1, limit: 25)
    visit("#{url}?#{{page: page, limit: limit}.to_query}")
  end

  def click_destroy_model_link
    click_destroy_link_for(model)
  end
end
