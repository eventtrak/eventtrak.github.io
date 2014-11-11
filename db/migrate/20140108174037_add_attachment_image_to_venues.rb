class AddAttachmentImageToVenues < ActiveRecord::Migration
  def self.up
    change_table :venues do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :venues, :image
  end
end
