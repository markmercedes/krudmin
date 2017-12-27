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

  it "can be displayed as datetime" do
    expect(subject.datetime).to eq("Thu, 14 Dec 1989 15:01:32 +0000")
  end

  describe "display formats" do
    let(:options) { {format: :short} }

    it do
      expect(subject.date).to eq("Dec 14")
    end
  end
end
