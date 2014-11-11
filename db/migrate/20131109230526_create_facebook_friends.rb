class CreateFacebookFriends < ActiveRecord::Migration
  def change
    create_table :facebook_friends do |t|
      t.integer :fbid1, limit: 8
      t.integer :fbid2, limit: 8;

      t.timestamps
    end
  end
end
