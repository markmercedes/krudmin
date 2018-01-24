class AddEmailToPassengers < ActiveRecord::Migration[5.1]
  def change
    add_column :passengers, :email, :string
  end
end
