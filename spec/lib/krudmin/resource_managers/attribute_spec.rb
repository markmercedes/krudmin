require 'spec_helper'

require "#{Dir.pwd}/lib/krudmin/fields/base"
require "#{Dir.pwd}/lib/krudmin/fields/number"
require "#{Dir.pwd}/lib/krudmin/fields/string"
require "#{Dir.pwd}/lib/krudmin/resource_managers/attribute"
require "#{Dir.pwd}/lib/krudmin/resource_managers/attribute_collection"

describe Krudmin::ResourceManagers::Attribute do
  describe "from" do
    let(:attribute) { :priority }

    subject { described_class.from(attribute, metadata) }

    context "hash" do
      let(:metadata) { {type: Krudmin::Fields::Number, decimals: 3} }

      it "maps types and options for base properties" do
        expect(subject.type).to eq(Krudmin::Fields::Number)
        expect(subject.new_field(double(priority: 9001.199999)).to_s).to eq("9001.200")
        expect(subject.html_class).to eq("text-right")
      end
    end

    context "given class" do
      let(:metadata) { Krudmin::Fields::Number }

      it "maps the types as there are no extra options given" do
        expect(subject.type).to eq(Krudmin::Fields::Number)
        expect(subject.new_field(double(priority: 9001.199999)).to_s).to eq("9001.199999")
        expect(subject.html_class).to eq("text-right")
      end
    end

    context 'with no given class' do
      let(:metadata) { nil }
      let(:attribute) { :other_attr }

      it "retutns a default attribute instance" do
        expect(subject.type).to eq(Krudmin::Fields::String)
        expect(subject.html_class).to be_empty
      end
    end
  end

  describe "type as hash" do
    let(:attribute) { :priority }
    let(:metadata) { {type: Krudmin::Fields::Number, decimals: 3} }

    subject { described_class.from(attribute, metadata) }

    it "converts itself into a valid hash" do
      expect(subject.type_as_hash).to eq(priority: {decimals: 3})
    end
  end

  describe "from list" do
    let(:attributes) { {priority: Krudmin::Fields::Number, description: Krudmin::Fields::String} }

    subject { described_class.from_list(attributes) }

    it "converts itself into a valid hash that contains a collection of the described_class" do
      expect(subject.keys).to eq([:priority, :description])
      expect(subject.values.map(&:attribute)).to eq([:priority, :description])
      expect(subject.values.map(&:type)).to eq([Krudmin::Fields::Number, Krudmin::Fields::String])
    end
  end
end
