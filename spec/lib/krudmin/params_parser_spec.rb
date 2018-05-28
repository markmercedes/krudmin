require "rails_helper"

describe Krudmin::ParamsParser do

  let(:resource_manager) { CarsResourceManager.new }
  subject { described_class.new(params, resource_manager) }

  let(:params) do
    HashWithIndifferentAccess.new({
      "car_model" => "Hello",
      "year" => "9001",
      "created_at" => "01/21/2018 06:49 PM",
      "release_date" => "02/01/2012"
    })
  end

  describe "date parsing" do
    it do
      expect(subject.to_h).to eq({
        "car_model" => "Hello",
        "year" => "9001",
        "created_at" => time_in_current_zone(2018, 1, 21, 18, 49),
        "release_date" => Date.new(2012, 02, 01)
      })
    end

    def time_in_current_zone(*args)
      Time.zone ? Time.zone.local(*args) : Time.new(*args)
    end
  end

  describe "params parsing" do
    let(:resource_manager) { CarsResourceManager.new }

    let(:params) do
      HashWithIndifferentAccess.new("passengers_attributes"=>{"0"=>{"name"=>"User One", "age"=>"28", "gender"=>"0", "email"=>"user@gmail.com", "_destroy"=>"false", "id"=>"13"}, "1"=>{"name"=>"User Two", "age"=>"42", "gender"=>"0", "email"=>"user@example.com", "_destroy"=>"false", "id"=>"14"}}, "car_insurance_attributes"=>{"id"=>"4", "_destroy"=>"false", "license_number"=>"User One", "date"=>"12/14/1989"}, "car_owner_attributes"=>{"id"=>"20", "_destroy"=>"false", "name"=>"User One", "license_number"=>"132"})
    end

    subject { described_class.new(params, resource_manager) }

    it "uses a resource manager as metadata provider and parses params with proper format" do
      expect(subject.to_h).to eq({"passengers_attributes"=>{"0"=>{"name"=>"User One", "age"=>"28", "gender"=>"0", "email"=>"user@gmail.com", "_destroy"=>"false", "id"=>"13"}, "1"=>{"name"=>"User Two", "age"=>"42", "gender"=>"0", "email"=>"user@example.com", "_destroy"=>"false", "id"=>"14"}}, "car_insurance_attributes"=>{"id"=>"4", "_destroy"=>"false", "license_number"=>"User One", "date"=>Date.parse("Thu, 14 Dec 1989")}, "car_owner_attributes"=>{"id"=>"20", "_destroy"=>"false", "name"=>"User One", "license_number"=>"132"}})
    end
  end
end
