require "rails_helper"

describe "line item index page", type: :feature do
  let(:car_model) { "Camry" }
  let(:new_car_model) { "Tacoma" }
  let!(:car) { create(:car, model: car_model) }

  let(:car_page) { CarPage.new(url: admin_cars_path, model: car) }

  before do
    car_page.visit_page
  end

  it "links to the show page of a given item" do
    click_show_link_for(car)
    expect(car_page).to have_content("Camry")
  end
end
