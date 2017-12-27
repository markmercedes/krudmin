require "spec_helper"
require "#{Dir.pwd}/lib/krudmin/fields/base"
require "#{Dir.pwd}/lib/krudmin/fields/associated"

describe Krudmin::Fields::Associated do
  let(:data) { 1 }
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

    describe "foreign_key" do
      module Ranger; end

      it "infers the class of the association" do
        expect(subject.associated_class).to eq(Ranger)
      end
    end
  end
end
