require "krudmin/engine"
require "haml"
require_relative "../app/helpers/krudmin/curd_messages"
require_relative "../lib/krudmin/resource_managers/base"
require "krudmin/labelize_methods"
require "krudmin/navigation_items"
require_relative "config"

module Krudmin
  def self.config(&block)
    if block_given?
      Krudmin::Config.with(&block)
    else
      Krudmin::Config
    end
  end
end
