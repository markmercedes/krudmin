class AddTransmissionToCar < ActiveRecord::Migration[5.1]
  def change
    add_column :cars, :transmission, :int
  end
end
