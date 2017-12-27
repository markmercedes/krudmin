require "krudmin/engine"
require "haml"
require_relative "../app/helpers/krudmin/curd_messages"
require_relative "../lib/krudmin/resource_managers/base"
require "krudmin/labelize_methods"
require "krudmin/activable_labeler"
require "krudmin/navigation_items"
require "krudmin/search_form"
require_relative "config"
require "krudmin/fields/base"
require "krudmin/fields/string"
require "krudmin/fields/number"
require "krudmin/fields/date_time"
require "krudmin/fields/boolean"
require "krudmin/fields/associated"
require "krudmin/fields/belongs_to"
require "krudmin/fields/enum_type"

module Krudmin
  def self.config(&block)
    if block_given?
      Krudmin::Config.with(&block)
    else
      Krudmin::Config
    end
  end
end
