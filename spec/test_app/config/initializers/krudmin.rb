# Different ways to interact with Krudmin initializer

Krudmin::Config.with do |config|
  # config.current_user_method(&:current_user)
  config.menu_items = -> { [
      Krudmin::NavigationItems::Node.node_for("Admin Cars", 'car', module_path: :admin, icon: :car),
      Krudmin::NavigationItems::Node.node_for("Car Brands", 'car_brand', module_path: :admin, icon: :car)
    ]
  }
end

Krudmin::config do |cfg|
  cfg.krudmin_root_path = :admin_cars_path
  cfg.pundit_enabled = true
end

config = Krudmin::config
