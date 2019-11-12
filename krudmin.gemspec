$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "krudmin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "krudmin"
  s.version     = Krudmin::VERSION
  s.authors     = ["Marcos Mercedes"]
  s.email       = ["marcos.mercedesn@gmail.com"]
  s.homepage    = "https://github.com/markmercedes/krudmin"
  s.summary     = "A Framework on top of Rails engine that provides easy ways to manage your backend data."
  s.description = "A Framework on top of Rails engine that provides easy ways to manage your backend data."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "bootstrap", ">= 4.1.3", "< 4.4.0"
  s.add_dependency "cocoon"
  s.add_dependency "font-awesome-rails"
  s.add_dependency "hamlit"
  s.add_dependency "jquery-rails"
  s.add_dependency "kaminari"
  s.add_dependency "momentjs-rails"
  s.add_dependency "pundit"
  s.add_dependency "ransack"
  s.add_dependency "sassc-rails"
  s.add_dependency "simple_form"
  s.add_dependency "summernote-rails"
  s.add_dependency "turbolinks"
end
