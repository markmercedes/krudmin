class Passenger < ApplicationRecord
  belongs_to :car

  # validates :name, :age, :gender, presence: true
  validates :name, :age, presence: true

  enum gender: {male: 0, female: 1}

  def gender=(value)
    super(value.size == 1 ? value.to_i : value)
  end
end
