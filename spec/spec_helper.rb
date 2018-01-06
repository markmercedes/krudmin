require 'simplecov'
require 'active_support/all'
require 'active_model'

SimpleCov.start

I18n.backend.store_translations(:en,
  YAML.load_file(File.open('./config/locales/en.yml'))['en']
)

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
    mocks.syntax = :expect
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
