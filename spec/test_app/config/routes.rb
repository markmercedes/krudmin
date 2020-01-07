Rails.application.routes.draw do
  root to: "docs#index"

  resources :docs

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

  namespace :krudmin do
    devise_for :profile, class_name: "Krudmin::User", controllers: { sessions: "krudmin/sessions", passwords: "krudmin/passwords" }

    resources :users do
      member do
        post :activate
        post :deactivate
        post :send_reset_password_instructions
      end
    end
  end
end
