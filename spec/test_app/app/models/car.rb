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

  enum transmission: {automatic: 0, manual: 1}

  delegate :description, to: :car_brand, prefix: true, allow_nil: true

  def activate!
    update_attribute(:active, true) unless cant_be_touched?
  end

  def deactivate!
    update_attribute(:active, false) unless cant_be_touched?
  end

  # There is an special trick for Camry 1989, it can't be activated or deactivated
  def cant_be_touched?
    (model == "Camry" && year == 1989)
  end

  def destroy
    super unless cant_be_touched?
  end

  def transmission=(value)
    super(value.size == 1 ? value.to_i : value)
  end
end
