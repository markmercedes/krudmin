Rails.application.routes.draw do
  mount Krudmin::Engine => "/krudmin"

  namespace :admin do
    resources :car_brands

    resources :cars do
      member do
        post :activate
        post :deactivate
      end
    end
  end

  namespace :console do
    resources :cars do
      member do
        post :activate
        post :deactivate
      end
    end
  end
end
