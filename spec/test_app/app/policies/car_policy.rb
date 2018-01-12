class CarPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def show?
    true
  end

  def edit?
    true
  end

  def new?
    true
  end

  def create?
    true
  end

  def update?
    true
  end

  def destroy?
    true
  end

  def activate?
    true
  end

  def deactivate?
    true
  end
end
