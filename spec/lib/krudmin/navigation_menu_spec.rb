require "spec_helper"

require_relative '../../../lib/krudmin/navigation_menu'
require_relative '../../../lib/krudmin/navigation_menu/node'

describe Krudmin::NavigationMenu do
  before do
    routes = double(
      link: :link,
      admin_cars_path: :admin_cars_path_link,
      admin_cars_path_link: :admin_cars_path_link,
      new_admin_car_path: :new_admin_car_path_link,
      new_admin_car_path_link: :new_admin_car_path_link
    )
    allow_any_instance_of(described_class::Node).to receive(:routes).and_return(routes)
    allow(described_class::Node).to receive(:routes).and_return(routes)
  end

  subject { described_class.new }

  describe "link" do
    it "adds a link entry to the menu" do
      subject.link "Label", :link, module_path: :admin, icon: :gear
      expect(subject.count).to eq(1)
    end
  end

  describe "node" do
    it "adds a node entry to the menu" do
      subject.node "Admin Cars", 'car', module_path: :admin, icon: :car
      expect(subject.count).to eq(1)
      expect(subject.first.map(&:label)).to eq(["Manage", "Add"])
    end
  end
end
