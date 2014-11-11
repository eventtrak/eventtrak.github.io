# == Schema Information
#
# Table name: facebook_friends
#
#  id         :integer          not null, primary key
#  fbid1      :integer
#  fbid2      :integer
#  created_at :datetime
#  updated_at :datetime
#

class FacebookFriend < ActiveRecord::Base
  # attr_accessible :fbid1, :fbid2
end
