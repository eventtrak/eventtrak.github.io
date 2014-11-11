# == Schema Information
#
# Table name: venue_dates
#
#  id         :integer          not null, primary key
#  date       :datetime
#  venue_id   :integer
#  event_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class VenueDate < ActiveRecord::Base

  belongs_to :venue
  belongs_to :event
end
