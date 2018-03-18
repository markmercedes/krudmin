require "spec_helper"
require "#{Dir.pwd}/lib/krudmin/fields/base"
require "#{Dir.pwd}/lib/krudmin/fields/date"
require "#{Dir.pwd}/lib/krudmin/fields/date_time"

describe Krudmin::Fields::DateTime do
  let(:date) { DateTime.new(1989, 12, 14, 15, 01, 32) }
  let(:model) { double(birthday: date) }
  let(:options) { {} }

  subject { described_class.new(:birthday, model, options) }

  it "hash a value" do
    expect(subject.attribute).to eq :birthday
    expect(subject.data).to eq(date)
  end

  context "datetime" do
    let(:options) { {format: "%H %d %p"} }

    it "can be displayed as datetime" do
      expect(subject.to_s).to eq("15 14 PM")
    end
  end

  context "date" do
    describe "display formats" do
      let(:options) { {format: :short} }
      let(:date) { Date.new(1989, 12, 14) }

      it do
        expect(subject.to_s).to eq("14 Dec 00:00")
      end
    end
  end

  context "time and others" do
    describe "fallbacks to datetime" do
      let(:options) { {format: :short} }
      let(:date) { Time.new(1989, 12, 14, 4, 0).utc }

      it do
        expect(subject.to_s).to eq(date.to_s(:short))
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
