class CreateVenueDates < ActiveRecord::Migration
  def change
    create_table :venue_dates do |t|
      t.datetime :date
      t.integer :venue_id
      t.integer :event_id

      t.timestamps
    end
  end
end
