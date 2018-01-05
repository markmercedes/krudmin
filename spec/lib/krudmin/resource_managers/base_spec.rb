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
      description: Krudmin::Fields::String,
      year: {type: Krudmin::Fields::Number, decimals: 3},
    }
  end

  subject { MockedGateway.new }

  it "maps types and options for base properties" do
    expect(subject.field_type_for(:priority)).to eq(Krudmin::Fields::Number)
    expect(subject.field_for(:priority, double(priority: 9001.199999)).to_s).to eq("9001.200")
    expect(subject.html_class_for(:priority)).to eq("text-right")
  end

  it "maps types and options for associated properties" do
    expect(subject.field_type_for(:year, root: :properties)).to eq(Krudmin::Fields::Number)
    expect(subject.field_options_for(:year, root: :properties)).to eq({decimals: 3})
  end

  it do
    expect(subject.model_label(OpenStruct.new(description: "hello"))).to eq("hello")
  end

  it do
    expect(subject.field_type_for(:description)).to eq(Krudmin::Fields::String)
    expect(subject.field_for(:description, double(description: "Llame pa verte")).to_s).to eq("Llame pa verte")
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
      expect(subject.attribute_types).to eq(
        {
          priority: {type: Krudmin::Fields::Number, decimals: 3},
          properties: {type: Krudmin::Fields::HasMany, decimals: 3},
          "properties__types" => Krudmin::Fields::HasMany.new(:properties, nil).associated_resource_manager_class::ATTRIBUTE_TYPES
        }
      )
    end

    it do
      expect(subject.field_for(:year, nil, root: :properties)).to be_a(Krudmin::Fields::Number)
      expect(subject.field_for(:year, nil, root: :properties).options).to eq({:decimals=>3})
    end
  end
end
