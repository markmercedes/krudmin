require "jquery-rails"
require "kaminari"
require "momentjs-rails"
require "selectize-rails"
require "sass-rails"
require "font-awesome-rails"
require "bootstrap"
require "simple_form"
require "turbolinks"
require "pundit"
require "arbre"
require "ransack"
require "cocoon"
require_relative "../../config/initializers/simple_form_bootstrap"
require_relative "../../app/controllers/krudmin/concerns/pundit_authorizable"

module Krudmin
  class Engine < ::Rails::Engine
    isolate_namespace Krudmin

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    config.after_initialize do
      config.i18n.load_path += Dir["#{config.root}/config/locales/**/*.yml"]
    end
  end
end
