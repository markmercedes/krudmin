require "rails_helper"

describe "line item index page", type: :feature do
  let(:car_model) { "Camry" }
  let(:new_car_model) { "Tacoma" }
  let!(:car) { create(:car, model: car_model) }

  let(:car_page) { CarPage.new(url: admin_cars_path, model: car) }

  before do
    car_page.visit_page
  end

  it "links to the edit page of a given item" do
    click_edit_link_for(car)

    fill_in(:car_model, with: new_car_model)

    car_page.click_save_model_button

    expect(car_page).to have_modified_message_visible(new_car_model)
  end
end
