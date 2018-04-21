Rails.application.routes.draw do
  root to: "admin/cars#index"

  namespace :admin do
    resources :car_brands

    resources :customs, only: [:index, :show]

    resources :cars do
      member do
        post :activate
        post :deactivate
      end
    end
  end
end
