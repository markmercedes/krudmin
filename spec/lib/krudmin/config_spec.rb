require 'spec_helper'
require "#{Dir.pwd}/lib/config"

describe Krudmin::Config do
  let(:current_user) { double(name: "user_name", email: "user@example.com") }

  describe "with" do
    it do
      described_class.with do |config|
        config.current_user_method(&:current_user)
      end
    end
  end
end
