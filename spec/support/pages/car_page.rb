class CarPage
  include Capybara::DSL
  include FactoryBot::Syntax::Methods
  include Rails.application.routes.url_helpers
  include Features

  def description
    model.model
  end

  attr_reader :url, :model
  def initialize(url:, model:)
    @url = url
    @model = model
  end

  def on_index_page?
    has_content?("Manage Cars")
  end

  def on_edit_page?
    has_content?("Edit #{description}") && has_field?(:car_model, with: description)
  end

  def has_destroyed_message_visible?
    has_content?("#{description} was successfully destroyed")
  end

  def has_modified_message_visible?(description)
    has_content?("#{description} was successfully modified") && has_field?(:car_model, with: description)
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

  def click_activate_model_link
    click_activation_link_for(model)
  end

  def click_deactivate_model_link
    click_deactivation_link_for(model)
  end

  def has_model_activated?
    has_content?("#{description} was successfully activated")
  end

  def has_model_deactivated?
    has_content?("#{description} was successfully deactivated")
  end

  def click_save_model_button
    first('.btn-primary').click
  end
end
