require "rails_helper"

describe "line item index page", type: :feature do
  let(:car_model) { "Camry" }
  let(:new_car_model) { "Tacoma" }
  let(:car_page) { CarPage.new(url: edit_admin_car_path(car), model: car) }

  before do
    car_page.visit_page
  end

  context "is activated" do
    let(:car) { create(:car, model: car_model, active: false) }

    it "links to the edit page of a given item" do
      car_page.click_activate_model_link(:form)

      expect(car_page).to have_model_activated && be_on_edit_page
    end
  end

  context "cant' be activated" do
    let(:car) { create(:car, model: car_model, active: false, year: 1989) }

    it "displays a message indicating that the model couldn't be activated" do
      car_page.click_activate_model_link(:form)

      expect(car_page).to have_model_unable_to_be_activated
      expect(car_page).to be_on_edit_page

      car.reload

      expect(car.active).to be_falsey
    end
  end
end
