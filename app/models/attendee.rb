# == Schema Information
#
# Table name: attendees
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  event_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Attendee < ActiveRecord::Base
  # attr_accessible :event_id, :user_id

  belongs_to :event
  belongs_to :user

  def is_backer
    return self.id < 51 && self.event_id == 1
  end
end
