Rails.application.routes.draw do
  root to: "docs#index"

  resources :docs, only: [:index, :show]

  resources :car_brands

  namespace :admin do
    root to: "cars#index"

    resources :customs, only: [:index, :show]

    resources :cars do
      member do
        post :activate
        post :deactivate
      end
    end
  end
end
