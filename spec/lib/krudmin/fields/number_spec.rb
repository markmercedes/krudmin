require "spec_helper"
require "#{Dir.pwd}/lib/krudmin/fields/base"
require "#{Dir.pwd}/lib/krudmin/fields/number"

describe Krudmin::Fields::Number do
  let(:number_value) { 9_001 }
  let(:model) { double(level: number_value) }
  let(:options) { {} }

  subject { described_class.new(:level, model, options ) }

  it "is aligned to the right" do
    expect(described_class::HTML_CLASS).to eq('text-right')
    expect(subject.html_class).to eq('text-right')
  end

  it "hash a value" do
    expect(subject.attribute).to eq :level
    expect(subject.value).to eq 9001
  end

  describe "options" do
    context "with multiplier" do
      let(:options) { {multiplier: 10} }

      it "multiplies output by the given multiplier" do
        expect(subject.value).to eq(90_010)
      end
    end

    context "with limited decimals" do
      let(:model) { double(level: 7.123456) }
      let(:options) { {decimals: 2} }

      it "truncates size to given decimal number" do
        expect(subject.to_s).to eq("7.12")
        expect(subject.value).to eq(7.12)
      end
    end
  end

  describe "to_s" do
    context "with decimals" do
      let(:options) { {decimals: 3} }

      it "adds the decimals even if the number is an integer with no decimals" do
        expect(subject.to_s).to eq("9001.000")
      end
    end

    context "with valid number" do
      it "shows an string representation of the number" do
        expect(subject.to_s).to eq("9001")
      end
    end

    context "with padding" do
      context "default padding" do
        let(:options) { {padding: 7} }

        it "shows an string representation of the number" do
          expect(subject.to_s).to eq("0009001")
        end
      end

      context "custom padding character" do
        let(:options) { {pad_with: "*", padding: 7} }

        it "shows an string representation of the number" do
          expect(subject.to_s).to eq("***9001")
        end
      end

      context "with prefix and padding" do
        let(:options) { {padding: 7, prefix: "CK-"} }

        it "shows an string representation of the number" do
          expect(subject.to_s).to eq("CK-0009001")
        end
      end
    end

    context "with nil data" do
      let(:number_value) { nil }

      it "shows an string representation of the number" do
        expect(subject.to_s).to eq('-')
        expect(subject.value).to be_nil
      end
    end
  end
end
