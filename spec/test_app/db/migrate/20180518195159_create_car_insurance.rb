class CreateCarInsurance < ActiveRecord::Migration[5.2]
  def change
    create_table :car_insurances do |t|
      t.date :date
      t.string :license_number
      t.references :car, unique: true
    end
  end
end
