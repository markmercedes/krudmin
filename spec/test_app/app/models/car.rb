class Car < ApplicationRecord
  include Krudmin::LabelizedMethods
  validates :model, :year, presence: true
  validates :year, numericality: { only_integer: true }
  validates :year, length: { is: 4 }
end
