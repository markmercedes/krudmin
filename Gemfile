source 'https://rubygems.org'

# Declare your gem's dependencies in krudmin.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]

group :development, :test do
  gem "factory_bot_rails"
  gem "ffaker"
  gem "haml-rails"
  gem "pg"
  gem "pry"
end

group :test do
  gem "database_cleaner"
  gem "guard-rspec"
  gem "poltergeist"
  gem 'capybara-screenshot'
  gem "pundit"
  gem "rspec_junit_formatter"
  gem "rspec-rails"
  gem "simplecov"
  gem "timecop"
  gem "webmock"
end
