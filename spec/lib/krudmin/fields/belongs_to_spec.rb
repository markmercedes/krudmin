require "spec_helper"
require "#{Dir.pwd}/lib/krudmin/activable_labeler"
require "#{Dir.pwd}/lib/krudmin/fields/base"
require "#{Dir.pwd}/lib/krudmin/fields/associated"
require "#{Dir.pwd}/lib/krudmin/fields/belongs_to"

describe Krudmin::Fields::BelongsTo do
  let(:data) { 1 }
  subject { described_class.new(:ranger, data) }

  module Ranger
    class << self
      def all
        [
          OpenStruct.new(name: "Rambo", id: 1),
          OpenStruct.new(name: "Chuck Norris", id: 2),
          OpenStruct.new(name: "Arnold", id: 3)
        ]
      end

      def main
        [
          OpenStruct.new(name: "Rambo", id: 1)
        ]
      end
    end
  end

  context "inferred relations" do
    describe "selected" do
      it "returns the same result as value" do
        expect(subject.selected).to eq(subject.value)
        expect(subject.selected).to eq(1)
      end
    end

    describe "associated_options" do
      it "returns all the records by default" do
        expect(subject.associated_options).to eq(Ranger.all)
      end
    end

    describe "associated_options" do
      subject { described_class.new(:ranger, data, {association_predicate: -> (source) { source.main }}) }

      it "executes the main method as the given scope" do
        expect(subject.associated_options).to eq(Ranger.main)
      end
    end
  end
end
