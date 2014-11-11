class AddHasTempPasswordToUsers < ActiveRecord::Migration
  def change
    add_column :users, :has_temp_password, :boolean
  end
end
