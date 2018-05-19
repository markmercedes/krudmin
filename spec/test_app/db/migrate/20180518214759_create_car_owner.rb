class CreateCarOwner < ActiveRecord::Migration[5.2]
  def change
    create_table :car_owners do |t|
      t.string :name
      t.integer :license_number
    end

    add_reference :cars, :car_owner
  end
end
