require "jquery-rails"
require "kaminari"
require "momentjs-rails"
require "sass-rails"
require "font-awesome-rails"
require "bootstrap"
require "simple_form"
require "turbolinks"
require "pundit"
require "arbre"
require "ransack"
require "cocoon"
require "trix"
require_relative "../config"

module Krudmin
  class Engine < ::Rails::Engine
    isolate_namespace Krudmin

    config.generators do |gen|
      gen.test_framework :rspec
      gen.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    config.after_initialize do
      config.i18n.load_path += Dir["#{config.root}/config/locales/**/*.yml"]
    end
  end
end
