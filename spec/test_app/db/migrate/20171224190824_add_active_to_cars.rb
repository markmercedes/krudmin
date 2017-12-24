class AddActiveToCars < ActiveRecord::Migration[5.1]
  def change
    add_column :cars, :active, :boolean
  end
end
