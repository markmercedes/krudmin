require 'spec_helper'

require "#{Dir.pwd}/lib/krudmin/search_form"

describe Krudmin::SearchForm::CalendarFilter do
  module MockedModel
    def self.human_attribute_name(attribute)
      attribute
    end
  end

  subject { described_class.for(:arrival_date, search_criteria, MockedModel) }

  describe "for" do
    context 'with from and to dates' do
      let(:search_criteria) { {"arrival_date__from"=>"2017-11-10", "arrival_date__from_options"=>"gteq", "arrival_date__to"=>"2017-11-15", "arrival_date__to_options"=>"lteq"} }

      it "generates filter descriptions for the beginning and the end of the date range" do
        expect(subject).to eq(["`arrival_date` Is greater than or equal to < 2017-11-10 >", "`arrival_date` Is less than or equal to < 2017-11-15 >"])
      end
    end

    context 'with from and to dates' do
      let(:search_criteria) { {"arrival_date__to"=>"2017-11-15", "arrival_date__to_options"=>"lteq"} }

      it "generates filter description for the end of the date range" do
        expect(subject).to eq(["`arrival_date` Is less than or equal to < 2017-11-15 >"])
      end
    end

    context 'with from and to dates' do
      let(:search_criteria) { {"arrival_date__from"=>"2017-11-10", "arrival_date__from_options"=>"gteq"} }

      it "generates filter description for the beginning of the date range" do
        expect(subject).to eq(["`arrival_date` Is greater than or equal to < 2017-11-10 >"])
      end
    end
  end
end
