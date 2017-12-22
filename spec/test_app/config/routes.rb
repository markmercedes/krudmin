Rails.application.routes.draw do
  mount Krudmin::Engine => "/krudmin"

  namespace :admin do
    resources :cars
  end
end
