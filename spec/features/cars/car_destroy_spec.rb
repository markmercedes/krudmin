require "rails_helper"

describe "line item index page", type: :feature do
  let(:car_model) { "Camry" }
  let!(:car) { create(:car, model: car_model) }

  let(:car_page) { CarPage.new(url: admin_cars_path, model: car) }

  before do
    car_page.visit_page
  end

  context "on a successful destroy" do
    it "destroys a given item if the corresponding destroy button is clicked" do
      expect(car_page).to have_model_visible

      car_page.click_destroy_model_link

      expect(car_page).to be_on_index_page
      expect(car_page).to have_destroyed_message_visible
      expect(car_page).not_to have_model_visible
    end
  end

  context "on an unsuccessful destroy" do
    let!(:car) { create(:car, model: car_model, year: 1989) }

    it "displays message indicating that the model couldn't be destroyed" do
      expect(car_page).to have_model_visible

      car_page.click_destroy_model_link

      expect(car_page).to be_on_index_page
      expect(car_page).to have_model_unable_to_be_destroyed
    end
  end
end
