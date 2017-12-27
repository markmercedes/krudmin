require "spec_helper"
require "#{Dir.pwd}/lib/krudmin/fields/base"
require "#{Dir.pwd}/lib/krudmin/fields/date_time"

describe Krudmin::Fields::DateTime do
  let(:date) { DateTime.new(1989, 12, 14, 15, 01, 32) }
  let(:data) { date }
  let(:options) { {} }

  subject { described_class.new(:birthday, data, options) }

  it "hash a value" do
    expect(subject.attribute).to eq :birthday
    expect(subject.value).to eq(date)
  end

  it "can be displayed as date" do
    expect(subject.date).to eq("1989-12-14")
  end

  context "datetime" do
    let(:options) { {format: "%H %d %p"} }

    it "can be displayed as datetime" do
      expect(subject.datetime).to eq("15 14 PM")
      expect(subject.to_s).to eq("15 14 PM")
    end
  end

  context "date" do
    describe "display formats" do
      let(:options) { {format: :short} }
      let(:date) { Date.new(1989, 12, 14) }

      it do
        expect(subject.to_s).to eq("Dec 14")
        expect(subject.date).to eq("Dec 14")
      end
    end
  end

  context "time and others" do
    describe "fallbacks to datetime" do
      let(:options) { {format: :short} }
      let(:date) { Time.new(1989, 12, 14) }

      it do
        expect(subject.to_s).to eq("14 Dec 04:00")
      end
    end
  end
end
