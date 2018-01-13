class CreateCarBrands < ActiveRecord::Migration[5.1]
  def change
    create_table :car_brands do |t|
      t.string :description, null: false
      t.timestamps
    end
  end
end
