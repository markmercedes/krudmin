require "spec_helper"
require "#{Dir.pwd}/lib/krudmin/fields/base"
require "#{Dir.pwd}/lib/krudmin/fields/hidden"

describe Krudmin::Fields::Hidden do
  let(:value) { 9_001 }
  let(:model) { double(level: value) }
  let(:options) { {} }

  subject { described_class.new(:level, model, options ) }

  it "has no padding on lists" do
    expect(described_class::HTML_CLASS).to eq('no-padding')
    expect(subject.html_class).to eq('no-padding')
  end

  describe "rendering contexts" do
    it "renders nothing on lists" do
      expect(subject.render(:list)).to be_nil
    end

    it "renders nothing on show" do
      expect(subject.render(:show)).to be_nil
    end

    it "renders nothing on search" do
      expect(subject.render(:search)).to be_nil
    end
  end
end
