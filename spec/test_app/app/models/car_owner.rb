class CarOwner < ApplicationRecord
  has_many :cars, dependent: :nullify

  validates :name, presence: true
end
