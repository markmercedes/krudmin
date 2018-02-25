class AddReleaseDateToCars < ActiveRecord::Migration[5.1]
  def change
    add_column :cars, :release_date, :date
  end
end
