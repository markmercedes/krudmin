require 'spec_helper'

require "#{Dir.pwd}/lib/krudmin/search_form"

describe Krudmin::SearchForm do
  let(:fields) { [:name, :age, :active] }

  module MockedModel
    def self.type_for_attribute(attribute)
      case attribute
      when "active"
        OpenStruct.new(type: :boolean)
      else
        OpenStruct.new(type: :string)
      end
    end

    def self.human_attribute_name(attribute)
      attribute
    end
  end

  subject { described_class.new(fields, MockedModel) }

  describe "Dynamic attribute assignment" do
    it do
      subject.name = :MyName
      subject.active = "true"
      expect(subject.name).to eq(:MyName)
      expect(subject.attrs).to eq({"name" => :MyName, "active" => "true"})

      subject.age = 9001
      expect(subject.attrs).to eq({"name" => :MyName, "age" => 9001, "active" => "true"})

      expect{ subject.undefined_field }.to raise_error(NoMethodError)
    end
  end

  describe "to_s" do
    context "boolean fields" do
      it do
        subject.fill_with({"active" => "true", "active_options" => "false"})

        expect(subject.filters).to eq(["Is not `active`"])

        subject.fill_with({"active" => "true", "active_options" => "true"})

        expect(subject.filters).to eq(["Is `active`"])
      end
    end
  end

  describe "fill_with" do
    it do
      stuff = {name: "MyName", name_options: "cont", age: 9000, age_options: "gt"}
      expect(subject.fill_with(stuff)).to eq({"name_cont"=>"MyName", "age_gt"=>9000})
      expect(subject.filters).to eq(["`name` Contains < MyName >", "`age` Is greater than < 9000 >"])
    end
  end
end
