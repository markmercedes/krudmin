class Car < ApplicationRecord
  include Krudmin::ActivableLabeler

  validates :model, :year, presence: true
  validates :year, numericality: { only_integer: true }
  validates :year, length: { is: 4 }

  has_many :passengers
  accepts_nested_attributes_for :passengers, reject_if: :all_blank, allow_destroy: true

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  belongs_to :car_brand

  def activate!
    update_attribute(:active, true)
  end

  def deactivate!
    update_attribute(:active, false)
  end
end
