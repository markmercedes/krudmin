require "spec_helper"
require "#{Dir.pwd}/lib/krudmin/activable_labeler"
require "#{Dir.pwd}/lib/krudmin/fields/base"
require "#{Dir.pwd}/lib/krudmin/fields/boolean"

describe Krudmin::Fields::Boolean do
  subject { described_class.new(:level, model) }

  context "true" do
    let(:model) { double(level: true) }

    it "generates a decorated label with positive value inside" do
      expect(subject.to_s.to_s).to eq("<span class=\"badge badge-success\">Yes</span>")
    end
  end

  context "false" do
    let(:model) { double(level: false) }

    it "generates a decorated label negative true value inside" do
      expect(subject.to_s.to_s).to eq("<span class=\"badge badge-danger\">No</span>")
    end
  end
end
