# == Schema Information
#
# Table name: band_members
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  artist_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class BandMember < ActiveRecord::Base
  # attr_accessible :artist_id, :user_id

  belongs_to :user
  belongs_to :artist
end
