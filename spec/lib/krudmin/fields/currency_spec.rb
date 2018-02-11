require "spec_helper"
require "#{Dir.pwd}/lib/krudmin/fields/base"
require "#{Dir.pwd}/lib/krudmin/fields/currency"

describe Krudmin::Fields::Currency do
  let(:number_value) { 9_001 }
  let(:model) { double(level: number_value) }
  let(:options) { {} }

  subject { described_class.new(:level, model, options ) }

  it "hash a value" do
    expect(subject.attribute).to eq :level
    expect(subject.value).to eq 9001
  end

  describe "rendering" do
    let(:fake_view_context) { double }

    context "list" do
      it "renders a number in currency format with a configurable unit" do
        expect(fake_view_context).to receive(:number_to_currency).with(9001.0, precision: 2, unit: "$") { :mocked }

        expect(subject.render(:list, fake_view_context)).to eq :mocked
      end
    end
  end

  describe "options" do
    context "with multiplier" do
      let(:options) { {multiplier: 10} }

      it "multiplies output by the given multiplier" do
        expect(subject.value).to eq(90_010)
      end
    end

    context "without prefix specified" do
      let(:model) { double(level: 7.123456) }

      it "add a default prefix" do
        expect(subject.prefix).to eq("$")
      end
    end

    context "with prefix specified" do
      let(:model) { double(level: 7.123456) }
      let(:options) {{ prefix: "$$"}}

      it "add a default prefix" do
        expect(subject.prefix).to eq("$$")
      end
    end

    context "without decimals specifed" do
      let(:model) { double(level: 7.123456) }

      it "truncates size to the default size" do
        expect(subject.value).to eq(7.12)
      end
    end

    context "with limited decimals" do
      let(:model) { double(level: 7.123456) }
      let(:options) { {decimals: 3} }

      it "truncates size to given decimal number" do
        expect(subject.value).to eq(7.123)
      end
    end
  end
end
