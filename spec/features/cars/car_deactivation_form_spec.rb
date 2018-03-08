require "rails_helper"

describe "line item index page", type: :feature do
  let(:car_model) { "Camry" }
  let(:new_car_model) { "Tacoma" }
  let!(:car) { create(:car, model: car_model, active: true) }

  let(:car_page) { CarPage.new(url: edit_admin_car_path(car), model: car) }

  before do
    car_page.visit_page
  end

  context "is deactivated" do
    it "links to the edit page of a given item" do
      car_page.click_deactivate_model_link(:form)

      expect(car_page).to have_model_deactivated && be_on_edit_page
    end
  end
end
