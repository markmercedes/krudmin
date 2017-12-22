require "jquery-rails"
require "kaminari"
require "momentjs-rails"
require "selectize-rails"
require "sass-rails"
require "font-awesome-rails"
require "bootstrap"
require "simple_form"
require "turbolinks"
require_relative "../../config/initializers/simple_form_bootstrap"

module Krudmin
  class Engine < ::Rails::Engine
    isolate_namespace Krudmin

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end
  end
end
