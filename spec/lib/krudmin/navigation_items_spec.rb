require 'spec_helper'

require_relative '../../../lib/krudmin/navigation_items'

describe Krudmin::NavigationItems do
  before do
    stuff = double(link: :link)
    allow_any_instance_of(Krudmin::NavigationItems).to receive(:routes).and_return(stuff)
    allow_any_instance_of(Krudmin::NavigationItems::Node).to receive(:routes).and_return(stuff)
    allow(Krudmin::NavigationItems::Node).to receive(:routes).and_return(stuff)
  end

  let(:items) {
    [
      Krudmin::NavigationItems::Node.new(:label, :link),
      Krudmin::NavigationItems::Node.new(:label, :link, visible: false),
    ]
  }

  let(:user) { double(:user) }
  let(:instance) { described_class.new(user: user, items: items) }

  it 'only exposes visible items' do
    expect(instance.to_a.size).to be 1
  end

  describe Krudmin::NavigationItems::Node do
    let(:instance) { described_class.new("Link Label", "My Link", icon: :iconName) }

    describe "plain properties" do
      it {
        expect(instance.label).to eql("Link Label")
        expect(instance.link).to eql("My Link")
        expect(instance.icon).to eql(:iconName)
        expect(instance.label_class).to eql("menu-node-link-label")
        expect(instance.visible).to be_truthy
      }
    end

    describe "exposed children items" do
      let(:items) {
        [
          described_class.new(:label, :link),
          described_class.new(:label, :link, visible: false),
        ]
      }

      let(:root_node) { described_class.new(:label, :link, items: items) }

      it 'only exposes visible items' do
        expect(root_node.to_a.size).to be 1
      end
    end
  end
end
