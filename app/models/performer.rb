# == Schema Information
#
# Table name: performers
#
#  id         :integer          not null, primary key
#  artist_id  :integer
#  event_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Performer < ActiveRecord::Base

  belongs_to :artist
  belongs_to :event

  def display
    self.artist.artist_name
  end

  def display_link
    a = self.artist
    route = a.route
    name = CGI::escapeHTML a.artist_name
    "<a class='EventArtistLink' id='eventDylanLink' href='/%s'> %s </a>" % [route, name]
  end
end
