require "spec_helper"
require "#{Dir.pwd}/lib/krudmin/fields/base"
require "#{Dir.pwd}/lib/krudmin/fields/decimal"

describe Krudmin::Fields::Decimal do
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
      it "renders a decimal with a configurable delimiter" do
        expect(fake_view_context).to receive(:number_with_delimiter).with(9001.0, precision: 2, delimiter: ",", separator: ".") { :mocked }

        expect(subject.render(:list, fake_view_context)).to eq :mocked
      end
    end
  end

  describe "options" do

    context "without delimiter specified" do
      it "add a default delimiter" do
        expect(subject.delimiter).to eq(",")
      end
    end

    context "with delimiter specified" do
      let(:options) {{ delimiter: ",,"}}

      it "add a default delimiter" do
        expect(subject.delimiter).to eq(",,")
      end
    end

    context "without decimals specifed" do
      it "truncates size to the default size" do
        expect(subject.decimals).to eq(2)
      end
    end

    context "with limited decimals" do
      let(:options) { {decimals: 3} }

      it "truncates size to given decimal number" do
        expect(subject.decimals).to eq(3)
      end
    end

    context "without separator specifed" do
      it "truncates size to the default size" do
        expect(subject.separator).to eq(".")
      end
    end

    context "with limited separator" do
      let(:options) { {separator: "-"} }

      it "truncates size to given decimal number" do
        expect(subject.separator).to eq("-")
      end
    end
  end
end
