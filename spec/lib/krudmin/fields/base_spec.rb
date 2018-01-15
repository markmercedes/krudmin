require "spec_helper"
require "#{Dir.pwd}/lib/krudmin/fields/base"

describe Krudmin::Fields::Base do
  let(:model) { double(name: "Goku") }
  let(:options) { {resource: "Humanoid"} }

  subject { described_class.new(:name, model, options ) }

  it "Extracts the resource from the options hash and removes that key without modifying the original options hash" do
    expect(subject.resource).to eq("Humanoid")
    expect(subject.options).to eq({})
    expect(options[:resource]).to eq("Humanoid")
  end

  it do
    expect(described_class.is?(Krudmin::Fields::Base)).to be_truthy
  end

  it "hash a value" do
    expect(subject.attribute).to eq :name
    expect(subject.value).to eq "Goku"
  end

  it "infers it's own type" do
    expect(subject.field_type).to eq("base")
    expect(described_class.field_type).to eq("base")
  end

  describe "render" do
    context "default" do
      it do
        expect(subject.render(:show)).to eq("Goku")
      end
    end

    context "with custom renderer" do
      let(:model) { double(name: "Goku") }
      let(:options) { {resource: "Humanoid", present_with: FieldWithCustomPresenter} }
      subject { described_class.new(:name, model, options ) }

      it "is able to render custom views" do
        class FieldWithCustomPresenter < Krudmin::Presenters::BaseFieldPresenter
          def render_show
            view_context.render("/krudmin/fields/#{page}")
          end
        end

        fake_view_context = double

        custom_field = FieldWithCustomPresenter

        expect(fake_view_context).to receive(:render).with("/krudmin/fields/show") { "Yep" }

        expect(subject.render(:show, fake_view_context)).to eq "Yep"
      end
    end
  end
end
