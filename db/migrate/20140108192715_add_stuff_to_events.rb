class AddStuffToEvents < ActiveRecord::Migration
  def change
    add_column :events, :artist_id, :integer
    add_column :events, :goal, :integer
  end
end
