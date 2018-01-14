class CarBrandPolicy < CarPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end
end
