module Krudmin
  class User < ApplicationRecord
    self.table_name = :users

    enum role: { admin: 1, user: 2 }

    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable,
           :recoverable, :rememberable, :trackable, :validatable

    validates :name, presence: true
    validates :role, :email, presence: true

    validates :email, uniqueness: true
    validates :password, presence: true, if: :password_required?
    validates_length_of :password, minimum: 6, allow_blank: true
    validates_confirmation_of :password

    def active_for_authentication?
      super && active?
    end

    def role=(value)
      super(value.size == 1 ? value.to_i : value)
    end

    def activate!
      update_attributes(active: true)
    end

    def deactivate!
      update_attributes(active: false)
    end
  end
end
