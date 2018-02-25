require "spec_helper"
require "#{Dir.pwd}/lib/krudmin/params_parser"

describe Krudmin::ParamsParser do

  let(:input_date_format) { "%m/%d/%Y %I:%M %p" }

  let(:params) do
    {
      "string_type" => "Hello",
      "int_type" => "9001",
      "datetime_field" => "01/21/2018 06:49 PM",
      "date_field" => "02/01/2012"
    }
  end

  class MockedModelClass
    class << self
      def columns_hash
        {
          "datetime_field" => OpenStruct.new(type: :datetime),
          "int_type" => OpenStruct.new(type: :integer),
          "string_type" => OpenStruct.new(type: :string),
          "date_field" => OpenStruct.new(type: :date)
        }
      end
    end
  end

  subject { described_class.new(params, MockedModelClass) }

  describe "date parsing" do
    it do
      expect(subject.to_h).to eq({
        "string_type" => "Hello",
        "int_type" => "9001",
        "datetime_field" => DateTime.new(2018, 01, 21, 18, 49),
        "date_field" => Date.new(2012, 02, 01)
      })
    end
  end
end
