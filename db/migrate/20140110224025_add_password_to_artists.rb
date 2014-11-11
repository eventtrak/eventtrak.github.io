class AddPasswordToArtists < ActiveRecord::Migration
  def change
    add_column :artists, :password_digest, :string
    add_column :artists, :remember_token, :string
  end
end
