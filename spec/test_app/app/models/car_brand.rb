class CarBrand < ApplicationRecord
  validates :description, uniqueness: true, presence: true

  has_many :cars
end
