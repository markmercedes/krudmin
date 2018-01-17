require "spec_helper"
require "#{Dir.pwd}/lib/krudmin/activable_labeler"
require "#{Dir.pwd}/lib/krudmin/fields/base"
require "#{Dir.pwd}/lib/krudmin/fields/associated"
require "#{Dir.pwd}/lib/krudmin/fields/has_many"

describe Krudmin::Fields::HasMany do
  let(:model) { double(id: 1, ranger: 1, class: double(table_name: "rangers")) }
  subject { described_class.new(:rangers, model) }

  module Ranger
    class << self
      def rangers
        [
          OpenStruct.new(name: "Rambo", id: 1, ranger_id: 1),
          OpenStruct.new(name: "Chuck Norris", id: 2, ranger_id: 1),
          OpenStruct.new(name: "Arnold", id: 3, ranger_id: 1)
        ]
      end
    end
  end

  context "inferred relations" do
    describe "association_name" do
      it "equals :ranger" do
        expect(subject.association_name).to eq(:rangers)
      end
    end

    describe "primary_key" do
      it "equals id" do
        expect(subject.primary_key).to eq(:id)
      end
    end

    describe "foreign_key" do
      it "equals ranger_id" do
        expect(subject.foreign_key).to eq(:ranger_id)
      end
    end

    describe "associated_class_name" do
      it "infers the class name of the association" do
        expect(subject.associated_class_name).to eq("Ranger")
      end
    end

    describe "associated_class" do
      it "infers the class of the association" do
        expect(subject.associated_class).to eq(Ranger)
      end
    end

    describe "associated resource manager" do
      module RangersResourceManager; end

      it "infers the class of the associated resource manager" do
        expect(subject.associated_resource_manager_class_name).to eq("RangersResourceManager")
        expect(subject.associated_resource_manager_class).to eq(RangersResourceManager)
      end
    end

    describe "associated resource manager" do
      let(:resource_double) { double }

      module ResourceDouble
        def self.new
          OpenStruct.new(items: Ranger.rangers)
        end

      end

      subject {
        described_class.new(:rangers, model,
          association_predicate:->(*){Ranger.rangers},
          resource_manager: :ResourceDouble)
      }

      it "infers the class of the associated resource manager" do
        expect(subject.associated_resource_manager_class).to eq(ResourceDouble)
        expect(subject.associated_collection).to eq(Ranger.rangers)
      end
    end

    describe "partials" do
      describe "partial_form" do
        context "default" do
          it "returns the default value" do
            expect(subject.partial_form).to eq(:form)
          end
        end

        context "with custom option" do
          subject { described_class.new(:rangers, model, {partial_form: "other"}) }

          it "returns the custom value" do
            expect(subject.partial_form).to eq("other")
          end
        end
      end

      describe "partial_display" do
        context "default" do
          it "returns the default value" do
            expect(subject.partial_display).to eq(:show)
          end
        end

        context "with custom option" do
          subject { described_class.new(:rangers, model, {partial_display: "other"}) }

          it "returns the custom value" do
            expect(subject.partial_display).to eq("other")
          end
        end
      end

      describe "child_partial_form" do
        context "default" do
          it "returns the default value" do
            expect(subject.child_partial_form).to eq(:form_fields)
          end
        end

        context "with custom option" do
          subject { described_class.new(:rangers, model, {child_partial_form: "other"}) }

          it "returns the custom value" do
            expect(subject.child_partial_form).to eq("other")
          end
        end
      end

      describe "child_partial_display" do
        context "default" do
          it "returns the default value" do
            expect(subject.child_partial_display).to eq(:show_fields)
          end
        end

        context "with custom option" do
          subject { described_class.new(:rangers, model, {child_partial_display: "other"}) }

          it "returns the custom value" do
            expect(subject.child_partial_display).to eq("other")
          end
        end
      end
    end
  end
end
