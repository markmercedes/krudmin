class LinkCarsWithCarBrands < ActiveRecord::Migration[5.1]
  def change
    add_reference :cars, :car_brand
  end
end
