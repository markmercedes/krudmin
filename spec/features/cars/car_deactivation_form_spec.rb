require "rails_helper"

describe "line item index page", type: :feature do
  let(:car_model) { "Camry" }
  let(:new_car_model) { "Tacoma" }

  let(:car_page) { CarPage.new(url: edit_admin_car_path(car), model: car) }

  before do
    car_page.visit_page
  end

  context "is deactivated" do
    let!(:car) { create(:car, model: car_model, active: true) }

    it "links to the edit page of a given item" do
      car_page.click_deactivate_model_link(:form)

      expect(car_page).to have_model_deactivated && be_on_edit_page
    end
  end

  context "can't be deactivated" do
    let!(:car) { create(:car, model: car_model, active: true, year: 1989) }

    it "links to the edit page of a given item" do
      car_page.click_deactivate_model_link(:form)

      expect(car_page).to have_model_unable_to_be_deactivated
      expect(car_page).to be_on_edit_page

      car.reload

      expect(car.active).to be_truthy
    end
  end
end
