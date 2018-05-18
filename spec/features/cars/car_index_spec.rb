require "rails_helper"

describe "line item index page", type: :feature do
  let(:car_model) { "Camry" }
  let!(:car) { create(:car, model: car_model) }

  let(:car_page) { CarPage.new(url: admin_cars_path, model: car) }

  before do
    car_page.visit_page
  end

  it "renders a list of items in the index page" do
    expect(car_page).to be_on_index_page
    expect(car_page).to have_model_visible
  end

  it "renders a custom label in the index page" do
    expect(car_page).to have_content 'Is Active'
  end

  it "links to the show page of a given item" do
    click_show_link_for(car)

    expect(page).to have_content("Edit #{car_model}")
  end

  it "links to the edit page of a given item" do
    click_edit_link_for(car)

    expect(car_page).to be_on_edit_page
  end
end
