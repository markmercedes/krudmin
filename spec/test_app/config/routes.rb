Rails.application.routes.draw do
  root to: "admin/cars#index"

  namespace :admin do
    resources :car_brands

    resources :cars do
      member do
        post :activate
        post :deactivate
      end
    end
  end
end
