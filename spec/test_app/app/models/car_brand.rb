class CarBrand < ApplicationRecord
  validates :description, uniqueness: true, presence: true

  has_many :cars

  scope :search_by_term, -> (term) { where("description ILIKE ?", "%#{term}%").limit(10) }
end
