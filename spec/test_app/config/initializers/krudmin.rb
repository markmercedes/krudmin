Krudmin::Config.with do |config|
  # config.current_user_method(&:current_user)

  config.menu_items = -> { [
      Krudmin::NavigationItems::Node.node_for("Admin Cars", 'car', module_path: :admin, manage: false, icon: :car),
      Krudmin::NavigationItems::Node.node_for("Console Cars", 'car', module_path: :console, add: false, icon: :car)
    ]
  }
end
