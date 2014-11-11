class AddSocialLinksToArtists < ActiveRecord::Migration
  def change
    add_column :artists, :youtube, :string
    add_column :artists, :twitter, :string
    add_column :artists, :facebook, :string
    add_column :artists, :instagram, :string
  end
end
