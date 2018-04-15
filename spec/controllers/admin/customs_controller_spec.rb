require "rails_helper"

describe Admin::CustomsController, type: :controller do
  describe "GET index" do
    it "renders the index" do
      get :index

      expect(response).to be_successful
    end
  end

  describe "GET show" do
    it "renders a show page for the given resource" do
      get :show, params: {id: 1}

      expect(response).to be_successful
    end
  end
end
