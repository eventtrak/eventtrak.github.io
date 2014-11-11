class AddEmailToArtists < ActiveRecord::Migration
  def change
    add_column :artists, :email, :string
  end
end
