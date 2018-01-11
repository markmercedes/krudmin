require 'spec_helper'

require "krudmin/activable_labeler"
require "krudmin/search_form"
require "krudmin/fields/base"
require "krudmin/fields/string"
require "krudmin/fields/number"
require "krudmin/fields/date_time"
require "krudmin/fields/boolean"
require "krudmin/fields/associated"
require "krudmin/fields/belongs_to"
require "krudmin/fields/enum_type"

describe Krudmin::SearchForm do
  let(:fields) { [:name, :age, :active, :arrival_date] }

  module MockedModel
    def self.type_for_attribute(attribute)
      case attribute.to_s
      when "arrival_date"
        OpenStruct.new(type: :date)
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

  describe "Dynamic attribute assignment" do
    it do
      subject.arrival_date__from = "2017-11-11"
      expect(subject.arrival_date__from).to eq("2017-11-11")

      subject.arrival_date__from_options = :gteq

      subject.fill_with({"arrival_date__from" => "2017-11-10", "arrival_date__from_options" => "gteq", "arrival_date__to" => "2017-11-15", "arrival_date__to_options" => "lteq"})

      expect(subject.fields).to eq([:name, :age, :active, :arrival_date])
      expect(subject.enhanced_fields).to eq([:name, :age, :active, :arrival_date__from, :arrival_date__to])

      expect(subject.params).to eq({"arrival_date_gteq"=>Date.parse("2017-11-10").beginning_of_day, "arrival_date_lteq"=>Date.parse("2017-11-15").end_of_day})

      expect(subject.attrs).to eq({"arrival_date__from"=>Date.parse("2017-11-10").beginning_of_day, "arrival_date__from_options" => "gteq", "arrival_date__to"=>Date.parse("2017-11-15").end_of_day, "arrival_date__to_options"=>"lteq"})

      expect(subject.filters).to eq(["`arrival_date` Is greater than or equal to < 2017-11-10 >", "`arrival_date` Is less than or equal to < 2017-11-15 >"])
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

    context "sorting fields" do
      it do
        expect(subject.sort_with("name desc")).to eq({s: "name desc"})
        expect(subject.s).to eq("name desc")
      end
    end
  end
end
