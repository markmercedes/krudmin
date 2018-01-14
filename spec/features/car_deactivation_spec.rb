require "rails_helper"

describe "line item index page", type: :feature do
  let(:car_model) { "Camry" }
  let(:new_car_model) { "Tacoma" }
  let!(:car) { create(:car, model: car_model, active: true) }

  let(:car_page) { CarPage.new(url: admin_cars_path, model: car) }

  before do
    car_page.visit_page
  end

  it "links to the edit page of a given item" do
    car_page.click_deactivate_model_link

    expect(car_page).to be_on_index_page

    expect(car_page).to have_model_deactivated
  end
end
