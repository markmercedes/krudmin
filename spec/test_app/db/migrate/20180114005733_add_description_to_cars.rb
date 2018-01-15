class AddDescriptionToCars < ActiveRecord::Migration[5.1]
  def change
    add_column :cars, :description, :text
  end
end
