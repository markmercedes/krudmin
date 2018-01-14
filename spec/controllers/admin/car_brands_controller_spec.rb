require "rails_helper"

describe Admin::CarBrandsController, type: :controller do
  describe "GET index" do
    it "renders the index" do
      get :index

      expect(response).to be_success
    end
  end

  describe "GET show" do
    it "renders a show page for the given resource" do
      car_brand = create(:car_brand)

      get :show, params: {id: car_brand.to_param}

      expect(response).to be_success
    end
  end

  describe "GET new" do
    it "renders a new resource page with a form" do
      get :new

      expect(response).to be_success
    end
  end

  describe "GET edit" do
    it "renders an edit resource page with a form" do
      car_brand = create(:car_brand)

      get :edit, params: {id: car_brand.to_param}

      expect(response).to be_success
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new car_brand" do
        expect {
          post :create, params: {car_brand: attributes_for(:car_brand)}
        }.to change(CarBrand, :count).by(1)
      end

      it "redirects to the created car_brand" do
        post :create, params: {car_brand: attributes_for(:car_brand)}

        new_car_brand = CarBrand.first

        expect(response).to redirect_to([:edit, :admin, new_car_brand])
      end
    end

    describe "with invalid params" do
      it "renders the new resource page with a form and the resource is not created" do
        invalid_attributes = { description: "" }

        expect {
          post :create, params: {car_brand: invalid_attributes}
        }.to change(CarBrand, :count).by(0)

        expect(response).to be_success
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested car_brand" do
        car_brand = create(:car_brand)
        new_desc = "new name"
        new_attributes = { description: new_desc }

        put :update, params: {id: car_brand.to_param, car_brand: new_attributes}

        car_brand.reload
        expect(car_brand.description).to eq new_desc
      end

      it "redirects to the car_brand" do
        car_brand = create(:car_brand)
        valid_attributes = attributes_for(:car_brand)

        put :update, params: {id: car_brand.to_param, car_brand: valid_attributes}

        expect(response).to redirect_to([:edit, :admin, car_brand])
      end
    end

    describe "with invalid params" do
      it "renders the edit resource page with a form and the resource attributes are not modified" do
        car_brand = create(:car_brand)
        original_desc = car_brand.description
        invalid_attributes = { description: "" }

        put :update, params: {id: car_brand.to_param, car_brand: invalid_attributes}

        car_brand.reload
        expect(car_brand.description).to eq original_desc
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested car_brand" do
      car_brand = create(:car_brand)

      expect do
        delete :destroy, params: {id: car_brand.to_param}
      end.to change(CarBrand, :count).by(-1)
    end

    it "redirects to the car_brands list" do
      car_brand = create(:car_brand)

      delete :destroy, params: {id: car_brand.to_param}

      expect(response).to redirect_to(admin_car_brands_url)
    end
  end
end
