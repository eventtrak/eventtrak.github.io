class CreateUserAnalytics < ActiveRecord::Migration
  def change
    create_table :user_analytics do |t|
      t.string :user_identifier
      t.boolean :is_registered
      t.string :url
      t.integer :action
      t.string :target
      t.string :value

      t.timestamps
    end
  end
end
