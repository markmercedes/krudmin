require "rails_helper"

describe "line item index page", type: :feature do
  let(:car_model) { "Camry" }

  let!(:car_brand) { create(:car_brand, description: "Toyota") }

  let!(:car) { create(:car, model: car_model, car_brand: car_brand) }
  let!(:passenger1) { create(:passenger, gender: 0, car: car) }
  let!(:passenger2) { create(:passenger, gender: 1, car: car) }

  let(:car_page) { CarPage.new(url: admin_cars_path, model: car) }

  before do
    car_page.visit_page
    click_show_link_for(car)
  end

  it "links to the show page of a given item" do
    expect(car_page).to have_text "Camry"
    expect(car_page).to have_text "CK0000000001"
    expect(car_page).to have_text car.year, count: 1
    expect(car_page).to have_text "Toyota", count: 1
  end

  it "shows a link to car model" do
    expect(car_page).to have_selector :link, "Toyota", href: "/car_brands/#{car_brand.id}"
  end

  it "shows a link to edit the car" do
    expect(car_page).to have_selector :link, "Edit Camry", href: "/admin/cars/#{car.id}/edit"
  end

  it "shows the passengers list" do
    expect(car_page).to have_text passenger1.name, count: 1
    expect(car_page).to have_text passenger1.age
    expect(car_page).to have_text "male"

    expect(car_page).to have_text passenger2.name, count: 1
    expect(car_page).to have_text passenger2.age
    expect(car_page).to have_text "female"
  end
end
