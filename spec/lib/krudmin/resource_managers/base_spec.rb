require 'spec_helper'
require 'rspec/mocks'

require "#{Dir.pwd}/lib/krudmin/fields/base"
require "#{Dir.pwd}/lib/krudmin/fields/number"
require "#{Dir.pwd}/lib/krudmin/fields/string"
require "#{Dir.pwd}/lib/krudmin/fields/associated"
require "#{Dir.pwd}/lib/krudmin/fields/has_many"
require "#{Dir.pwd}/lib/krudmin/resource_managers/base"

describe Krudmin::ResourceManagers::Base do
  class Krudmin::ItemSpecModel
    class << self
      def all
        [1,2,3]
      end

      def primary_key
        "id"
      end

      def column_names
        []
      end
    end
  end

  describe "grouped_attributes" do
    it do
      expect(subject.grouped_attributes).to eq({
        general: {attributes: [:description], label: "GENERALISIMO", class: "col-md-12"},
        props: {attributes: [:properties], class: "col-md-6", label: "Props"}
      })
    end
  end

  class MockedGateway < described_class
    MODEL_CLASSNAME = 'Krudmin::ItemSpecModel'
    LISTABLE_ATTRIBUTES = [:description, :priority]

    EDITABLE_ATTRIBUTES = {
      general: [:description],
      props: [:properties]
    }

    PRESENTATION_METADATA = {
      general: { label: "GENERALISIMO", class: "col-md-12" },
      props: { class: "col-md-6", label: "Props" }
    }

    LISTABLE_ACTIONS = [:show, :edit, :destroy, :active]
    ORDER_BY = {description: :desc}
    LISTABLE_INCLUDES = [:logs]
    RESOURCE_INSTANCE_LABEL_ATTRIBUTE = :description
    ATTRIBUTE_TYPES = {
      priority: {type: Krudmin::Fields::Number, decimals: 3},
      properties: {type: Krudmin::Fields::HasMany, decimals: 3},
    }
  end

  class PropertiesResourceManager < described_class
    MODEL_CLASSNAME = 'Krudmin::ItemSpecModel'
    EDITABLE_ATTRIBUTES = [:description, :year]

    ATTRIBUTE_TYPES = {
      year: {type: Krudmin::Fields::Number, decimals: 3},
    }
  end

  subject { MockedGateway.new }

  it "maps types and options for base properties" do
    expect(subject.field_for(:priority, double(priority: 9001.199999)).to_s).to eq("9001.200")
  end

  it "Extracts the value from the attribute configured as the source of the label for the" do
    expect(subject.model_label(OpenStruct.new(description: "hello"))).to eq("hello")
  end

  it "Initializes a field for a given attribute, the type is defined by the resource manager" do
    expect(subject.field_for(:description, double(description: "hello")).to_s).to eq("hello")
  end

  it do
    mocked_model_class = double()
    expect(mocked_model_class).to receive(:includes).with([:logs]) { mocked_model_class }
    expect(mocked_model_class).to receive(:order).with({description: :desc}) { [1, 2, 3] }
    expect(mocked_model_class).to receive(:all) { mocked_model_class }

    allow(subject).to receive(:model_class) { mocked_model_class }

    expect(subject.items).to eq([1, 2, 3])
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
        expect(MockedGateway.model_class).to eq(Krudmin::ItemSpecModel)
        expect(subject.scope).to eq(Krudmin::ItemSpecModel.all)
      end

      it do
        expect(subject.model_classname).to eq('Krudmin::ItemSpecModel')
      end

      it do
        expect(subject.listable_attributes).to eq([:description, :priority])
      end

      it do
        expect(subject.editable_attributes).to eq([:description, :properties])
      end

      it do
        expect(subject.permitted_attributes).to eq([:description, properties_attributes: [:id, :description, :year, :_destroy]])
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
    end
  end

  describe "attribute_types" do
    it do
      expect(subject.field_for(:year, root: :properties)).to be_a(Krudmin::Fields::Number)
      expect(subject.field_for(:year, root: :properties).options).to eq({:decimals=>3})
    end
  end
end
