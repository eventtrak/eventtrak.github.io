class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.integer :capacity
      t.integer :min_age
      t.string :equipment
      t.integer :min_price
      t.integer :max_price

      t.timestamps
    end
  end
end
