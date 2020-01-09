Krudmin::Engine.routes.draw do
  devise_for :profile, class_name: "Krudmin::User", controllers: { sessions: "krudmin/sessions", passwords: "krudmin/passwords" }

  resources :users do
    member do
      post :activate
      post :deactivate
      post :send_reset_password_instructions
    end
  end
end
