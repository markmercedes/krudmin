Krudmin::Config.with do |config|
  # config.current_user_method(&:current_user)
  config.krudmin_root_path = :admin_cars_path

  config.pundit_enabled = false

  config.menu_items = -> { [
      Krudmin::NavigationItems::Node.node_for("Admin Cars", 'car', module_path: :admin, icon: :car),
      Krudmin::NavigationItems::Node.node_for("Car Brands", 'car_brand', module_path: :admin, icon: :car)
    ]
  }
end
