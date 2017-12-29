require 'spec_helper'
require 'rspec/mocks'

require "#{Dir.pwd}/lib/krudmin/fields/base"
require "#{Dir.pwd}/lib/krudmin/fields/number"
require "#{Dir.pwd}/lib/krudmin/fields/string"
require "#{Dir.pwd}/lib/krudmin/resource_managers/base"

describe Krudmin::ResourceManagers::Base do
  class Krudmin::ItemSpecModel
    class << self
      def all
        [1,2,3]
      end
    end
  end

  let(:predefined_routes) { double() }

  class MockedGateway < described_class
    MODEL_CLASSNAME = 'Krudmin::ItemSpecModel'
    LISTABLE_ATTRIBUTES = [:description, :priority]
    EDITABLE_ATTRIBUTES = [:description]
    LISTABLE_ACTIONS = [:show, :edit, :destroy, :active]
    ORDER_BY = {description: :desc}
    LISTABLE_INCLUDES = [:logs]
    RESOURCE_INSTANCE_LABEL_ATTRIBUTE = :description
    PREPEND_ROUTE_PATH = :namespace
    RESOURCE_NAME = "Item"
    ATTRIBUTE_TYPES = {priority: [Krudmin::Fields::Number, {decimals: 3}]}
  end

  subject { MockedGateway.new }

  before do
    allow(subject).to receive(:routes) { predefined_routes }
  end

  it do
    expect(subject.field_type_for(:priority)).to eq(Krudmin::Fields::Number)
    expect(subject.field_for(:priority, 9001.199999).to_s).to eq("9001.200")
    expect(subject.html_class_for(:priority)).to eq("text-right")
  end

  it do
    expect(subject.model_label(OpenStruct.new(description: "hello"))).to eq("hello")
  end

  it do
    expect(subject.field_type_for(:description)).to eq(Krudmin::Fields::String)
    expect(subject.field_for(:description, "Llame pa verte").to_s).to eq("Llame pa verte")
  end

  it do
    mocked_model_class = double()
    expect(mocked_model_class).to receive(:includes).with([:logs]) { mocked_model_class }
    expect(mocked_model_class).to receive(:order).with({description: :desc}) { [1, 2, 3] }
    expect(mocked_model_class).to receive(:all) { mocked_model_class }

    allow(subject).to receive(:model_class) { mocked_model_class }

    expect(subject.items).to eq([1, 2, 3])
  end

  it do
    model_id = 1
    expect(predefined_routes).to receive(:new_namespace_item_path) { "new_path" }
    expect(predefined_routes).to receive(:activate_namespace_item_path).with(1) { "activate_path" }
    expect(predefined_routes).to receive(:deactivate_namespace_item_path).with(1) { "deactivate_path" }
    expect(predefined_routes).to receive(:namespace_item_path).with(1) { "resource_path" }
    expect(predefined_routes).to receive(:edit_namespace_item_path).with(1, {}) { "edit_resource_path" }
    expect(predefined_routes).to receive(:namespace_items_path) { "resource_root" }


    expect(subject.new_resource_path).to eq("new_path")
    expect(subject.activate_path(model_id)).to eq("activate_path")
    expect(subject.deactivate_path(model_id)).to eq("deactivate_path")
    expect(subject.resource_path(model_id)).to eq("resource_path")
    expect(subject.edit_resource_path(model_id)).to eq("edit_resource_path")
    expect(subject.resource_root).to eq("resource_root")
  end

  describe "label_for" do
    it do
      model = double(description: "My Description")
      expect(subject.label_for(model)).to eq("My Description")
    end
  end

  describe "constant delegations" do
    describe do
      it do
        expect(subject.scope).to eq(Krudmin::ItemSpecModel.all)
      end

      it do
        expect(subject.model_classname).to eq('Krudmin::ItemSpecModel')
      end

      it do
        expect(subject.listable_attributes).to eq([:description, :priority])
      end

      it do
        expect(subject.editable_attributes).to eq([:description])
      end

      it do
        expect(subject.permitted_attributes).to eq([:description])
      end

      it do
        expect(subject.listable_actions).to eq([:show, :edit, :destroy, :active])
      end

      it do
        expect(subject.order_by).to eq({description: :desc})
      end

      it do
        expect(subject.listable_includes).to eq([:logs])
      end

      it do
        expect(subject.resource_instance_label_attribute).to eq(:description)
      end

      it do
        expect(subject.prepend_route_path).to eq(:namespace)
      end

      it do
        expect(subject.resource_name).to eq('item')
      end

      it do
        expect(subject.resources_name).to eq('items')
      end
    end
  end

  describe "route path generation" do
    it do
      expect(subject.new_route_path).to eq("new_namespace_item_path")
    end

    it do
      expect(subject.prepend_route_path).to eq(:namespace)
    end

    it do
      expect(subject.activate_route_path).to eq("activate_namespace_item_path")
    end

    it do
      expect(subject.deactivate_route_path).to eq("deactivate_namespace_item_path")
    end

    it do
      expect(subject.resource_route_path).to eq("namespace_item_path")
    end

    it do
      expect(subject.edit_route_path).to eq("edit_namespace_item_path")
    end
  end
end
