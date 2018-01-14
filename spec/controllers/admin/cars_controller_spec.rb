require "rails_helper"

describe Admin::CarsController, type: :controller do

  render_views

  let(:car_brand) { create(:car_brand) }
  let(:car) { create(:car, car_brand: car_brand) }

  describe "GET index" do
    it "renders the index" do
      get :index

      expect(response).to be_success
    end
  end

  describe "GET show" do
    it "renders a show page for the given resource" do
      get :show, params: {id: car.to_param}

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
      get :edit, params: {id: car.to_param}

      expect(response).to be_success
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new car" do
        expect {
          post :create, params: {car: attributes_for(:car).merge(car_brand_id: car_brand.id)}
        }.to change(Car, :count).by(1)
      end

      it "redirects to the created car" do
        post :create, params: {car: attributes_for(:car).merge(car_brand_id: car_brand.id)}

        new_car = Car.first

        expect(response).to redirect_to([:edit, :admin, new_car])
      end
    end

    describe "with invalid params" do
      it "renders the new resource page with a form and the resource is not created" do
        invalid_attributes = { model: "" }

        expect {
          post :create, params: {car: invalid_attributes}
        }.to change(Car, :count).by(0)

        expect(response).to be_success
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested car" do
        new_model = "new name"
        new_attributes = { model: new_model }

        put :update, params: {id: car.to_param, car: new_attributes}

        car.reload
        expect(car.model).to eq new_model
      end

      it "redirects to the car" do
        valid_attributes = attributes_for(:car).merge(car_brand_id: car_brand.id)

        put :update, params: {id: car.to_param, car: valid_attributes}

        expect(response).to redirect_to([:edit, :admin, car])
      end
    end

    describe "with invalid params" do
      it "renders the edit resource page with a form and the resource attributes are not modified" do
        original_model = car.model
        invalid_attributes = { model: "" }

        put :update, params: {id: car.to_param, car: invalid_attributes}

        car.reload
        expect(car.model).to eq original_model
      end
    end
  end

  describe "DELETE destroy" do
    before do
      car # creates the car when the spec variable is invoked
    end

    it "destroys the requested car" do
      expect do
        delete :destroy, params: {id: car.to_param}
      end.to change(Car, :count).by(-1)
    end

    it "redirects to the cars list" do
      delete :destroy, params: {id: car.to_param}

      expect(response).to redirect_to(admin_cars_url)
    end
  end

  describe "ACTIVATE destroy" do
    let(:car) { create(:car, active: false, car_brand: car_brand) }

    it "activates the requested car" do
      expect do
        post :activate, params: {id: car.to_param}
      end.to change(Car.active, :count).by(1)
    end
  end

  describe "DEACTIVATE destroy" do
    let(:car) { create(:car, active: true, car_brand: car_brand) }

    it "deactivates the requested car" do
      expect do
        post :deactivate, params: {id: car.to_param}
      end.to change(Car.inactive, :count).by(1)
    end
  end
end
