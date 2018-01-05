require 'spec_helper'

require "#{Dir.pwd}/lib/krudmin/resource_managers/routing"

describe Krudmin::ResourceManagers::Routing do

  let(:predefined_routes) { double() }
  let(:resource) { :item }
  let(:model_id) { 1 }

  subject { described_class.new(resource) }

  before do
    allow(subject).to receive(:routes) { predefined_routes }
  end

  def test_routes(generator)
    expect(generator.new_resource_path).to eq("new_path")
    expect(generator.activate_path(model_id)).to eq("activate_path")
    expect(generator.deactivate_path(model_id)).to eq("deactivate_path")
    expect(generator.resource_path(model_id)).to eq("resource_path")
    expect(generator.edit_resource_path(model_id)).to eq("edit_resource_path")
    expect(generator.resource_root).to eq("resource_root")
  end

  context "without a prepended namespace" do
    it "generates routes methods withoud a namespace prepended" do
      expect(predefined_routes).to receive(:new_item_path) { "new_path" }
      expect(predefined_routes).to receive(:activate_item_path).with(1) { "activate_path" }
      expect(predefined_routes).to receive(:deactivate_item_path).with(1) { "deactivate_path" }
      expect(predefined_routes).to receive(:item_path).with(1) { "resource_path" }
      expect(predefined_routes).to receive(:edit_item_path).with(1, {}) { "edit_resource_path" }
      expect(predefined_routes).to receive(:items_path) { "resource_root" }

      test_routes(subject)
    end

    it "does not have a namespace" do
      expect(subject.namespace).to be_nil
    end
  end

  context "with a prepended namespace" do
    let(:prepended_path) { :namespace }
    subject { described_class.new(resource, prepended_path) }

    it "generates routes methods with a namespace prepended" do
      expect(predefined_routes).to receive(:new_namespace_item_path) { "new_path" }
      expect(predefined_routes).to receive(:activate_namespace_item_path).with(1) { "activate_path" }
      expect(predefined_routes).to receive(:deactivate_namespace_item_path).with(1) { "deactivate_path" }
      expect(predefined_routes).to receive(:namespace_item_path).with(1) { "resource_path" }
      expect(predefined_routes).to receive(:edit_namespace_item_path).with(1, {}) { "edit_resource_path" }
      expect(predefined_routes).to receive(:namespace_items_path) { "resource_root" }

      test_routes(subject)
    end

    it "has a namespace" do
      expect(subject.namespace).to eq(:namespace)
    end
  end
end
