class CreateBandMembers < ActiveRecord::Migration
  def change
    create_table :band_members do |t|
      t.belongs_to :user
      t.belongs_to :artist
      t.integer :artist_id
      t.integer :user_id

      t.timestamps
    end
  end
end
