# == Schema Information
#
# Table name: users
#
#  id                    :integer          not null, primary key
#  fname                 :string(255)
#  lname                 :string(255)
#  email                 :string(255)
#  password              :string(255)
#  is_beta_tester        :boolean
#  is_artist             :boolean
#  created_at            :datetime
#  updated_at            :datetime
#  password_digest       :string(255)
#  client_ip             :string(255)
#  facebook_id           :integer
#  has_temp_password     :boolean
#  remember_token        :string(255)
#  stripe_customer_token :string(255)
#  avatar_file_name      :string(255)
#  avatar_content_type   :string(255)
#  avatar_file_size      :integer
#  avatar_updated_at     :datetime
#

class User < ActiveRecord::Base
  # attr_accessible :email, :fname, :is_artist, :is_beta_tester, :lname, :password, :client_ip, :facebook_id, :has_temp_password, :remember_token, :stripe_customer_token, :avatar

  has_many :attendees
  has_many :events, through: :attendees
  has_one :artist, through: :band_members
  has_many :transactions

  has_one :band_member

  
  validates :fname, presence: true, length: { maximum: 50 }
  validates :lname, presence: true, length: { maximum: 50 }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  # validates :password, length: { minimum: 6, too_short: "should have at least %{count} characters" }, on: :create

  has_attached_file :avatar, s3_protocol: 'http'
  
  validate :should_not_have_profanities

  has_secure_password
  before_save { create_remember_token if (self.remember_token.blank? && self.password_digest && defined?(self.password_digest)) }
  before_save { |user| user.email = email.downcase }
  
  include UsersHelper
  
  def should_not_have_profanities
    if is_profane_name? fname or is_profane_name? lname
      errors.add(:name, "shouldn't contain profanities")
    end

    if is_profane_name? email
      errors.add(:email, "shouldn't contain profanities")
    end

  end


  DISPLAY_FIELDS = {fname: "First name", lname: "Last name", name: "Name", email: "Email", password: "Password" }

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

  def display_name
    return "#{ self.fname } #{ self.lname }"
  end

  def tickets
    return self.transactions.map(&:tickets).flatten
  end

  def facebook_profile_url
    return "https://graph.facebook.com/#{ self.facebook_id }/picture?width=172&height=172"
  end

  def is_backer_for_event_id(event_id)
    a = Attendee.find_by_user_id_and_event_id(self.id, event_id)
    return false if a.blank?
    return a.id < 51
  end

  private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
