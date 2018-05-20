class CarInsurance < ApplicationRecord
  belongs_to :car

  validates :license_number, presence: true
end
