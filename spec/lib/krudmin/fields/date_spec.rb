require "spec_helper"
require "#{Dir.pwd}/lib/krudmin/fields/base"
require "#{Dir.pwd}/lib/krudmin/fields/date"

describe Krudmin::Fields::Date do
  let(:date) { Date.new(1989, 12, 14) }
  let(:model) { double(birthday: date) }
  let(:options) { {} }

  subject { described_class.new(:birthday, model, options) }

  it "hash a value" do
    expect(subject.attribute).to eq :birthday
    expect(subject.value.to_date).to eq(date)
  end

  it "can be displayed as date" do
    expect(subject.to_s).to eq("1989-12-14")
  end

  context "date" do
    describe "display formats" do
      let(:options) { {format: :short} }
      let(:date) { Date.new(1989, 12, 14) }

      it do
        expect(subject.to_s).to eq("Dec 14")
      end
    end
  end

  context "time and others" do
    describe "fallbacks to datetime" do
      let(:options) { {format: :short} }
      let(:date) { Time.new(1989, 12, 14, 4, 0).utc }

      it do
        expect(subject.to_s).to eq("Dec 14")
      end
    end
  end

  context "with nil value" do
    let(:model) { double(birthday: nil) }

    it "returns nil" do
      expect(subject.to_s).to eq("-")
      expect(subject.data).to be_nil
    end
  end
end
