require "rails_helper"

describe "line item index page", type: :feature do
  let(:car_model) { "Camry" }
  let!(:car) { build_stubbed(:car) }
  let(:car_page) { CarPage.new(url: admin_cars_path, model: car) }

  before do
    create(:car_brand, description: "Toyota")

    car_page.visit_page
  end

  it "links to the edit page of a given item" do
    click_add_link

    fill_in(:car_model, with: car_model)
    fill_in(:car_year, with: 2009)
    # For now the car brand will be optional, because now this is a remote select and by default no options are loaded
    # select('Toyota', from: :car_car_brand_id)

    car_page.click_save_model_button

    expect(car_page).to have_created_message_visible("Camry")
  end
end
