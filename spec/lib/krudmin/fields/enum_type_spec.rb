require "spec_helper"
require "#{Dir.pwd}/lib/krudmin/fields/base"
require "#{Dir.pwd}/lib/krudmin/fields/associated"
require "#{Dir.pwd}/lib/krudmin/fields/belongs_to"
require "#{Dir.pwd}/lib/krudmin/fields/enum_type"

describe Krudmin::Fields::EnumType do
  subject { described_class.new(:ranger_id, double) }

  describe "linkable?" do
    context "default" do
      it "is not linkeable" do
        expect(subject.linkable?).to be_falsey
      end
    end
  end
end
