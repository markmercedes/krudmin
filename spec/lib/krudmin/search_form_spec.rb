require 'spec_helper'

require "#{Dir.pwd}/lib/krudmin/search_form"

describe Krudmin::SearchForm do
  let(:fields) { [:name, :age] }

  module MockedModel
    def self.type_for_attribute(*)
      OpenStruct.new(type: :string)
    end

    def self.human_attribute_name(attribute)
      attribute
    end
  end

  subject { described_class.new(fields, MockedModel) }

  describe "Dynamic attribute assignment" do
    it do
      subject.name = :nigga
      expect(subject.name).to eq(:nigga)
      expect(subject.attrs).to eq({"name" => :nigga})

      subject.age = 9001
      expect(subject.attrs).to eq({"name" => :nigga, "age" => 9001})

      expect{ subject.undefined_field }.to raise_error(NoMethodError)
    end
  end

  describe "fill_with" do
    it do
      stuff = {name: "nigga", name_options: "cont", age: 9000, age_options: "gt"}
      expect(subject.fill_with(stuff)).to eq({"name_cont"=>"nigga", "age_gt"=>9000})
      expect(subject.filters).to eq(["`name` contains < nigga >", "`age` greater than < 9000 >"])
    end
  end
end
