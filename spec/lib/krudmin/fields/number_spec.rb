require "spec_helper"
require "#{Dir.pwd}/lib/krudmin/fields/base"
require "#{Dir.pwd}/lib/krudmin/fields/number"

describe Krudmin::Fields::Number do
  let(:data) { 9001  }
  let(:options) { {resource: "Humanoid"} }

  subject { described_class.new(:level, data, options ) }

  it "is aligned to the right" do
    expect(described_class::HTML_CLASS).to eq('text-right')
    expect(subject.html_class).to eq('text-right')
  end

  it "Extracts the resource from the options hash and removes that key without modifying the original options hash" do
    expect(subject.resource).to eq("Humanoid")
    expect(subject.options).to eq({})
    expect(options[:resource]).to eq("Humanoid")
  end

  it "hash a value" do
    expect(subject.attribute).to eq :level
    expect(subject.value).to eq 9001
  end

  describe "options" do
    context "with multiplier" do
      let(:options) { {resource: "Humanoid", multiplier: 10} }

      it "multiplies output by the given multiplier" do
        expect(subject.value).to eq(90_010)
      end
    end

    context "with limited decimals" do
      let(:data) { 7.123456 }
      let(:options) { {resource: "Humanoid", decimals: 2} }

      it "truncates size to given decimal number" do
        expect(subject.to_s).to eq("7.12")
        expect(subject.value).to eq(7.12)
      end
    end
  end
end
