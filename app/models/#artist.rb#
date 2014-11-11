# == Schema Information
#
# Table name: artists
#
#  id              :integer          not null, primary key
#  artist_name     :string(255)
#  route_name      :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  password_digest :string(255)
#  remember_token  :string(255)
#  email           :string(255)
#  description     :text
#  youtube         :string(255)
#  twitter         :string(255)
#  facebook        :string(255)
#  instagram       :string(255)
#

class Artist < ActiveRecord::Base
  # attr_accessible :artist_name, :route_name

  include UsersHelper
  
  has_many :band_members
  has_many :users, through: :band_members
  has_many :events
  has_many :performers

  has_secure_password validations: false

  validate :should_not_have_profanities
  validates :artist_name, presence: true
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6, too_short: "should have at least %{count} characters" }, on: :create

  before_save { create_remember_token if (self.remember_token.blank? && self.password_digest && defined?(self.password_digest)) }
  before_save { generate_route if self.route_name.blank? }
  before_save { |user| user.email = email.downcase }

  DISPLAY_FIELDS = {name: "Name", artist_name: "Artist name", email: "Email", password: "Password" }

  def nice_messages
    out = []
    for tag, messages in errors.messages do
      nice_name = DISPLAY_FIELDS.fetch(tag, tag.to_s.capitalize)
      messages.each do |msg|
        m = "#{nice_name} #{msg}"
        m = m.sub(/\scan't\s/, " shouldn't ")
        out << m
      end
    end
    return out
  end

  include UsersHelper
  
  def should_not_have_profanities
    if is_profane_name? artist_name
      errors.add(:artist_name, "shouldn't contain profanities")
    end

    if is_profane_name? email
      errors.add(:email, "shouldn't contain profanities")
    end

  end

  def should_confirm_password?
    false
  end

  def generate_route
    base_route = route_from_artistname
    num = 0
    route = base_route
    while Artist.find_by_route_name(route) != nil
      num += 1
      route = base_route + num.to_s
    end
    self.route_name = route
  end

  def side_events
    self.performers.map(&:event)
  end

  def all_events
    events + side_events
  end

  def sorted_all_events
    all_events.sort { |x, y| x.venue_date.date <=> y.venue_date.date }
  end


  def route
    CGI::escapeHTML route_name
  end 

  
  private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

  def route_from_artistname
    regexp = %r{[^a-z0-9\-._~#\[\]@!$&()*+,;]}
    artist_name.strip.downcase.gsub(regexp, "")
  end

  #fiona's attempt
#  def create_SocialLinks
#    artist = Artist.find(params[:id])
#    artist.facebook = 
#    artist.twitter = 
#    artist.instagram = 
#    artist.youtube = 
#    artist.save
#  end

#  def update_SocialLinks
#    artist = Artist.find(params[:id])
#    artist.facebook = 
#    artist.twitter = 
#    artist.instagram = 
#    artist.youtube = 
#    artist.save
#  end


end
