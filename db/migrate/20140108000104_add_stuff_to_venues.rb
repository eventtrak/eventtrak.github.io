class AddStuffToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :city, :string
    add_column :venues, :state, :string
    add_column :venues, :name, :string
  end
end
