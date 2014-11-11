class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :fname
      t.string :lname
      t.string :email
      t.string :password
      t.boolean :is_beta_tester
      t.boolean :is_artist

      t.timestamps
    end
  end
end
