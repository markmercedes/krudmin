class CarOwner < ApplicationRecord
  has_many :cars, dependent: :nullify
end
