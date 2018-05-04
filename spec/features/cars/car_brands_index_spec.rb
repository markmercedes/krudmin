require "rails_helper"

describe "line item index page", type: :feature do
  let(:brand_name) { "Toyota" }
  let!(:car_brand) { create(:car_brand, description: brand_name) }

  let(:brand_page) { CarBrandPage.new(url: car_brands_path, model: car_brand) }

  before do
    brand_page.visit_page
  end

  it "renders a list of items in the index page" do
    expect(brand_page).to be_on_index_page
    expect(brand_page).to have_model_visible
  end

  it "links to the show page of a given item" do
    click_show_link_for(car_brand)

    expect(page).to have_content("Edit #{brand_name}")
  end

  it "links to the edit page of a given item" do
    click_edit_link_for(car_brand)

    expect(brand_page).to be_on_edit_page
  end

  it "has action buttons that destroy a given item" do
    expect(brand_page).to have_model_visible

    brand_page.click_destroy_model_link

    expect(brand_page).to be_on_index_page
    expect(brand_page).to have_destroyed_message_visible
    expect(brand_page).not_to have_model_visible
  end
end
