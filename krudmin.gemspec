$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "krudmin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "krudmin"
  s.version     = Krudmin::VERSION
  s.authors     = ["Marcos Mercedes"]
  s.email       = ["marcos.mercedesn@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Krudmin."
  s.description = "TODO: Description of Krudmin."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.3"

  s.add_development_dependency "sqlite3"
end
