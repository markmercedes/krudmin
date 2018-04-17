require 'rails_helper'

describe Car, type: :model do
  describe "activate!" do
    context "able to activate" do
      subject { described_class.new(model: "Camry", year: 1989, active: false) }

      it do
        expect(subject.activate!).to be_falsey
        expect(subject.active).to be_falsey
      end
    end

    context "cant be activated" do
      subject { described_class.new(active: false) }

      it do
        expect(subject.activate!).to be_truthy
        expect(subject.active).to be_truthy
      end
    end
  end

  describe "deactivate!" do
    context "able to deactivate" do
      subject { described_class.new(model: "Camry", year: 1989, active: true) }

      it do
        expect(subject.deactivate!).to be_falsey
        expect(subject.active).to be_truthy
      end
    end

    context "cant be deactivated" do
      subject { described_class.new(active: false) }

      it do
        expect(subject.deactivate!).to be_truthy
        expect(subject.active).to be_falsey
      end
    end
  end

  describe "deactivate!" do
    context "able to deactivate" do
      subject { described_class.new(model: "Camry", year: 1989, active: true) }

      it do
        expect(subject.destroy).to be_falsey
      end
    end
  end
end
