require 'spec_helper'
require 'capybara/poltergeist'
require 'capybara-screenshot/rspec'
require 'factory_bot_rails'
require 'database_cleaner'
require 'ffaker'

ENV['RAILS_ENV'] ||= 'test'
# require File.expand_path('../../config/environment', __FILE__)
require File.expand_path("../../spec/test_app/config/environment", __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

ActiveRecord::Migration.maintain_test_schema!

Dir[Rails.root.join("../../spec/support/**/*.rb")].each { |file| require file }

module Features
  include Formulaic::Dsl
end

def in_ci?
  ENV["CIRCLECI"].present?
end

RSpec.configure do |config|
  config.include Features, type: :feature
  config.include FactoryBot::Syntax::Methods
  config.include ControllerHelpers, type: :controller

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, inspector: false, js_errors: false)
  end

  Capybara.javascript_driver = :poltergeist
  Capybara::Screenshot.webkit_options = { width: 1280, height: 800 }
  Capybara::Screenshot.autosave_on_failure = true
  Capybara::Screenshot::RSpec.add_link_to_screenshot_for_failed_examples = true

  config.after do |example|
    if example.metadata[:type] == :feature and example.exception.present?
      unless in_ci?
        save_and_open_page

        save_and_open_screenshot if example.metadata[:js]
      end
    end
  end

  config.append_after(:each) do
    Capybara.reset_sessions!
  end

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature) do
    driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test

    unless driver_shares_db_connection_with_specs
      DatabaseCleaner.strategy = :truncation
    end
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end
end
