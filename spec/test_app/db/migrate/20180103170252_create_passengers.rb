class CreatePassengers < ActiveRecord::Migration[5.1]
  def change
    create_table :passengers do |t|
      t.string :name
      t.integer :age
      t.integer :gender
      t.references :car
    end
  end
end
