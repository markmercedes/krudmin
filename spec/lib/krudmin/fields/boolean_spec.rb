require "spec_helper"
require "#{Dir.pwd}/lib/krudmin/activable_labeler"
require "#{Dir.pwd}/lib/krudmin/fields/base"
require "#{Dir.pwd}/lib/krudmin/fields/boolean"
require "arbre"

describe Krudmin::Fields::Boolean do
  subject { described_class.new(:level, data) }

  context "true" do
    let(:data) { true }

    it "generates a decorated label with positive value inside" do
      expect(subject.to_s.to_s).to eq("<span class=\"badge badge-success\">Yes</span>\n")
    end
  end

  context "false" do
    let(:data) { false }

    it "generates a decorated label negative true value inside" do
      expect(subject.to_s.to_s).to eq("<span class=\"badge badge-danger\">No</span>\n")
    end
  end
end
