require 'spec_helper'

require "#{Dir.pwd}/lib/krudmin/fields/base"
require "#{Dir.pwd}/lib/krudmin/fields/string"
require "#{Dir.pwd}/lib/krudmin/fields/number"
require "#{Dir.pwd}/lib/krudmin/fields/text"
require "#{Dir.pwd}/lib/krudmin/fields/associated"
require "#{Dir.pwd}/lib/krudmin/fields/belongs_to"
require "#{Dir.pwd}/lib/krudmin/fields/has_many_ids"
require "#{Dir.pwd}/lib/krudmin/fields/inflector"
require "#{Dir.pwd}/lib/krudmin/resource_managers/attribute"
require "#{Dir.pwd}/lib/krudmin/resource_managers/attribute_collection"

describe Krudmin::ResourceManagers::AttributeCollection do
  let(:attribute_types) do
    {
      name: Krudmin::Fields::String,
      age: {type: :Number},
      description: "Text",
      skills: :HasManyIds,
    }
  end
  let(:editable_attributes) { [] }
  let(:attributes_metadata) { [] }
  let(:listable_attributes) { [] }
  let(:displayable_attributes) { [] }
  let(:searchable_attributes) { [] }
  let(:model) { double(primary_key: "pk_id", column_names: ["pk_id", "name", "age", "skills", "created_at", "updated_at"], columns_hash: {}, reflections: {}) }

  subject{ described_class.new(model, attribute_types, editable_attributes, listable_attributes, searchable_attributes, displayable_attributes, attributes_metadata) }

  let(:default_columns) { [:name, :age, :skills] }

  describe "attribute_types" do
    context 'default' do
      let(:attribute_types) { [] }

      it "returns an empty hash if no values are provided" do
        expect(subject.attribute_types).to eq({})
      end
    end

    context "with custom values" do
      let(:editable_attributes) { {main_info: [], extra_info: []} }

      it "returns an empty hash if no values are provided" do
        expect(subject.attribute_types.values.map(&:class).uniq).to eq([Krudmin::ResourceManagers::Attribute])
        expect(subject.attribute_types.values.map(&:type)).to eq([Krudmin::Fields::String, Krudmin::Fields::Number, Krudmin::Fields::Text, Krudmin::Fields::HasManyIds])
      end
    end
  end

  describe "column_names" do
    it "returns the columns of the model without the usual non editable fields: PK, created_at, updated_at" do
      expect(subject.column_names).to eq(default_columns)
    end
  end

  describe "editable_attributes" do
    context "default" do
      it "returns the model columns if no editable_attributes are provided" do
        expect(subject.editable_attributes).to eq(default_columns)
        expect(subject.permitted_attributes).to eq([:name, :age, {skills: []}])
      end
    end

    context "default" do
      let(:editable_attributes) { [:skills] }

      it "returns the model columns if no editable_attributes are provided" do
        expect(subject.permitted_attributes).to eq([{skills: []}])
      end
    end

    context "with custom values" do
      let(:editable_attributes) { [:name] }

      it "returns the model columns if no editable_attributes are provided" do
        expect(subject.editable_attributes).to eq([:name])
        expect(subject.permitted_attributes).to eq([:name])
      end
    end
  end

  describe "listable_attributes" do
    context "default" do
      it "returns the model columns if no editable_attributes are provided" do
        expect(subject.listable_attributes).to eq(default_columns)
      end
    end

    context "with custom values" do
      let(:listable_attributes) { [:name] }

      it "returns the specified model columns" do
        expect(subject.listable_attributes).to eq([:name])
      end
    end
  end

  describe "searchable_attributes" do
    context "default" do
      it "returns the model columns if no editable_attributes are provided" do
        expect(subject.searchable_attributes).to eq(default_columns)
      end
    end

    context "with custom values" do
      let(:searchable_attributes) { [:name] }

      it "returns the specified model columns" do
        expect(subject.searchable_attributes).to eq([:name])
      end
    end
  end

  describe "displayable_attributes" do
    context "default" do
      it "returns the model columns if no displayable_attributes are provided" do
        expect(subject.displayable_attributes).to eq(default_columns)
      end
    end

    context "with custom values" do
      let(:displayable_attributes) { [:name] }

      it "returns the specified model columns" do
        expect(subject.displayable_attributes).to eq([:name])
      end
    end
  end
end
