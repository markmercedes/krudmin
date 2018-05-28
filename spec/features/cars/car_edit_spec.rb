require "rails_helper"

describe "line item index page", type: :feature do
  let!(:brand) { create(:car_brand, description: "Toyota") }
  let!(:brand2) { create(:car_brand, description: "Honda") }
  let(:car_model) { "Camry" }
  let(:new_car_model) { "Tacoma" }

  let!(:passenger1) { create(:passenger, car: car) }
  let!(:passenger2) { create(:passenger, car: car) }

  let!(:car) { create(:car, model: car_model, car_brand: brand, transmission: 0) }

  let(:car_page) { CarPage.new(url: admin_cars_path, model: car) }

  before do
    car_page.visit_page
  end

  it "shows checkbox field for boolean type" do
    click_edit_link_for(car)
    expect(car_page).to have_css 'input#car_active'
    expect(car_page).to have_content 'Is Active'
  end

  it "shows the rich text field type" do
    click_edit_link_for(car)
    expect(car_page).to have_css 'trix-editor'
  end

  it "shows the select field for transmision" do
    click_edit_link_for(car)

    expect(car_page).to have_selector :select, "car[transmission]", selected: "automatic"
    expect(page).to have_selector :select, "car[transmission]", with_options: ["automatic", "manual"]
  end

  it "shows the select field for car brand" do
    click_edit_link_for(car)

    expect(car_page).to have_selector :select, "car[car_brand_id]", selected: "Toyota"
    # expect(page).to have_selector :select, "car[car_brand_id]", with_options: ["Toyota", "Honda"]
    # Only Toyota is visible, because this is a remote select and only the selected option is loaded
    expect(page).to have_selector :select, "car[car_brand_id]", with_options: ["Toyota"]
  end

  it "shows the email field type" do
    click_edit_link_for(car)
    expect(car_page).to have_selector :field, "car_passengers_attributes_0_email", with: passenger1.email
    expect(car_page).to have_selector :field, "car_passengers_attributes_1_email", with: passenger2.email
    expect(car_page).to have_css 'input[type="email"]', count: 2
  end

  it "links to the edit page of a given item" do
    click_edit_link_for(car)
    fill_in(:car_model, with: new_car_model)
    fill_in(:car_car_insurance_attributes_license_number, with: 123)

    car_page.click_save_model_button

    expect(car_page).to have_modified_message_visible(new_car_model)
  end
end
