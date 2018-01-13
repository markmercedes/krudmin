require "spec_helper"
require "#{Dir.pwd}/lib/krudmin/constants_to_methods_exposer"

describe extend Krudmin::ConstantsToMethodsExposer do
  class MockedClassForMethodsExposerModule
    MY_CONST = :value

    extend Krudmin::ConstantsToMethodsExposer

    constantized_methods :my_const
  end

  describe "constantized_methods" do
    context 'instance' do
      subject { MockedClassForMethodsExposerModule.new }

      it "generates an instance method that reads the constant value" do
        expect(subject.my_const).to eq(:value)
      end
    end

    context 'class' do
      subject { MockedClassForMethodsExposerModule }

      it "generates a class method that reads the constant value" do
        expect(subject.my_const).to eq(:value)
      end
    end
  end
end
