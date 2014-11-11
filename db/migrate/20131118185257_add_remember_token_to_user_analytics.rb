class AddRememberTokenToUserAnalytics < ActiveRecord::Migration
  def change
    add_column :user_analytics, :remember_token, :string
  end
end
