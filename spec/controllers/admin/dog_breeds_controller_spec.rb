require "rails_helper"

describe Admin::DogBreedsController, type: :controller do
  before do
    allow_any_instance_of(DogsApiGateway).to receive(:fetch_all).and_return({"germanshepherd" => []})

    allow_any_instance_of(DogsApiGateway).to receive(:breed_images).and_return([])
  end


  describe "GET index" do
    it "renders the index" do
      get :index

      expect(response).to be_successful
    end
  end

  describe "GET show" do
    it "renders a show page for the given resource" do
      get :show, params: {id: :germanshepherd}

      expect(response).to be_successful
    end
  end
end
