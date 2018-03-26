module Krudmin
  module HelperIncluder
    def include_helper(mod)
      include mod

      mod.public_instance_methods.each { |method_name| helper_method method_name }
    end
  end
end
