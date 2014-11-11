# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  artist_id  :integer
#  goal       :integer
#  title      :string(255)
#  body       :text
#

class Event < ActiveRecord::Base
  # attr_accessible :title, :body, :artist_id, :goal

  has_many :attendees
  has_many :users, through: :attendees
  has_many :tickets
  has_many :ticket_models

  has_one :venue_date
  
  belongs_to :artist

  has_many :performers

  def facebook_friends_going
    ff = []
    curr_user = current_user
    self.users.each do |u|
      if !FacebookFriend.find_by_fbid1_and_fbid2(curr_user.facebook_id, u.facebook_id).blank? or
          !FacebookFriend.find_by_fbid1_and_fbid2(u.facebook_id, curr_user.facebook_id).blank?
        ff << u
      else
        next
      end
    end
    return ff
  end
  def non_facebook_friends_going
    nff = []
    curr_user = current_user
    self.users.each do |u|
      if FacebookFriend.find_by_fbid1_and_fbid2(curr_user.facebook_id, u.facebook_id).blank? and
          FacebookFriend.find_by_fbid1_and_fbid2(u.facebook_id, curr_user.facebook_id).blank?
        nff << u
      else
        next
      end
    end
    return nff
  end
  def all_people_going
    return self.users
  end

  # def tickets
  #   tickets = []
  #   self.attendees.map(&:user).each do |u|
  #     trans = u.transactions
  #     tix = trans.map(&:tickets).flatten(1)
  #     tickets << tix
  #   end
  #   return tickets
  # end

  def percent_funded_raised
    raised = 0
    for t in self.tickets do
      raised += t.post_stripe_value
    end

    pf = (raised * 100.0) / self.goal
    return [pf, raised]
  end

  def percent_funded
    pf, _ =  percent_funded_raised
    return pf
  end

  def other_acts
    perfs = self.performers.map(&:display_link)
    
    if perfs.count == 0
      return ''
    elsif perfs.count == 1
      return 'with %s' % perfs
    elsif perfs.count == 2
      return 'with %s and %s' % perfs
    end

    out = 'with '
    for p in perfs[0..-2]
      out << p << ', '
    end
    out << 'and ' << perfs[-1]

    return out
  end

  def display_list_name
    city = self.venue_date.venue.city
    "#{city} Concert"
  end
  
end
