require 'rails_helper'

describe Krudmin::Presenters::HasManyFieldPresenter do
  let(:field) { Krudmin::Fields::HasMany.new(nil, nil, { child_partial_form: child_partial_path }) }
  let(:child_partial_path) { :has_many_form_fields }
  subject { described_class.new(field, :form) }

  context "default" do
    it "allows customization for child partial form" do
      expect(subject.form_fields_partial).to eq("krudmin/core_theme/fields/has_many/has_many_form_fields")
    end
  end

  context "with relative path" do
    let(:child_partial_path) { "/has_many_form_fields" }

    it "allows customization for child partial form" do
      expect(subject.form_fields_partial).to eq("has_many_form_fields")
    end
  end

  context "with absolute path" do
    let(:child_partial_path) { "//has_many_form_fields" }

    it "allows customization for child partial form" do
      expect(subject.form_fields_partial).to eq("/has_many_form_fields")
    end
  end
end
