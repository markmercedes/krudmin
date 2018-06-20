require "spec_helper"
require "#{Dir.pwd}/lib/krudmin/fields/base"
require "#{Dir.pwd}/lib/krudmin/fields/associated"

describe Krudmin::Fields::Associated do
  let(:data) { OpenStruct.new }
  subject { described_class.new(:ranger_id, data) }

  context "inferred relations" do
    describe "association_name" do
      it "equals :ranger" do
        expect(subject.association_name).to eq(:ranger)
      end
    end

    describe "primary_key" do
      it "equals id" do
        expect(subject.primary_key).to eq(:id)
      end
    end

    describe "foreign_key" do
      it "equals ranger_id" do
        expect(subject.foreign_key).to eq(:ranger_id)
      end
    end

    describe "foreign_key" do
      it "infers the class name of the association" do
        expect(subject.associated_class_name).to eq("Ranger")
      end
    end

    it "raises an error if the expected associated resource manager is not found" do
      expect{ subject.associated_resource_manager_class }.to raise_error(described_class::UndefinedResourceManagerForAssociation, "Undefined resource manager `RangersResourceManager` for attribute `ranger`")
    end

    describe "foreign_key" do
      module Ranger; end

      it "infers the class of the association" do
        expect(subject.associated_class).to eq(Ranger)
      end
    end

    describe "attribute_for_nested_form" do
      context "when the association is ready for nested attributes" do
        let(:data) { OpenStruct.new(ranger_attributes: nil) }

        it "returns attribute for the given association" do
          expect(subject.attribute_for_nested_form).to eq(:ranger)
        end
      end

      context "when the association is not ready for nested attributes" do
        it "raises an error indicating that accepts_nested_attributes_for needs to be defined for the given assocation" do
          expect{ subject.attribute_for_nested_form }.to raise_error(described_class::UndefinedAcceptsNestedAtributesForAssociation, "`accepts_nested_attributes_for :ranger` needs to be defined in OpenStruct")
        end
      end
    end
  end
end
