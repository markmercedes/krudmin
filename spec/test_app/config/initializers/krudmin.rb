# Different ways to interact with Krudmin initializer

Krudmin::Config.with do |config|
  # config.current_user_method(&:current_user)
  config.navigation_menu = -> {
    Krudmin::NavigationMenu.configure do |menu, user|
      menu.node "Cars", 'car', module_path: :admin, icon: :car, visible_if: -> { CarPolicy.new(nil, nil).index? }
      menu.node "Car Brands", 'car_brand', module_path: :admin, icon: :car
      menu.link "Customs", :admin_customs_path, module_path: :admin, icon: :gear
      menu.link "Dog Breeds", :admin_dog_breeds_path, module_path: :admin, icon: :paw
    end
  }
end

Krudmin::config do |cfg|
  cfg.krudmin_root_path = :admin_cars_path
  cfg.pundit_enabled = true
end

config = Krudmin::config
