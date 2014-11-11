class CreatePerformers < ActiveRecord::Migration
  def change
    create_table :performers do |t|
      t.integer :artist_id
      t.integer :event_id

      t.timestamps
    end
  end
end
