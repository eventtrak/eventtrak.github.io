class FixPasswordDigestSpelling < ActiveRecord::Migration
  def change
    rename_column :users, :passowrd_digest, :password_digest
  end
end
