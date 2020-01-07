module Krudmin
  class UserPolicy
    class Scope < Struct.new(:user, :scope)
      def policy
        @policy ||= policy_class.new(user, nil)
      end

      def policy_class
        self.class.ancestors.first.parent
      end

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

    def new?
      true
    end

    def create?
      true
    end

    def edit?
      manage?
    end

    def update?
      manage?
    end

    def destroy?
      manage?
    end

    def show?
      true
    end

    def activate?
      manage?
    end

    def deactivate?
      manage?
    end

    private

    def manage?
      admin? || user_managing_own_record?
    end

    def admin?
      user.role == "admin"
    end

    def user_managing_own_record?
      user.id == record.id
    end
  end
end
