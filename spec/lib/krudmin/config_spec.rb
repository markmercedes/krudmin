require 'spec_helper'
require "#{Dir.pwd}/lib/config"
require "#{Dir.pwd}/lib/krudmin/navigation_items"

describe Krudmin::Config do
  let(:current_user) { double(name: "user_name", email: "user@example.com") }
  let(:menu) do
    [
      Krudmin::NavigationItems::Node.new("Cars", 'car', icon: :car)
    ]
  end

  describe "with" do
    it do
      described_class.with do |config|
        config.current_user_method(&:current_user)
        config.menu_items = menu
      end
    end
  end
end
