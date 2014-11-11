# == Schema Information
#
# Table name: venues
#
#  id                 :integer          not null, primary key
#  capacity           :integer
#  min_age            :integer
#  equipment          :string(255)
#  min_price          :integer
#  max_price          :integer
#  created_at         :datetime
#  updated_at         :datetime
#  city               :string(255)
#  state              :string(255)
#  name               :string(255)
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  address            :string(255)
#  url                :string(255)
#


class Venue < ActiveRecord::Base
  
  has_many :events, through: :venue_dates
  has_many :venue_dates
  has_attached_file :image, s3_protocol: 'http'

  def image_path
    if (!self.image_file_name.blank? && self.image_file_name.include?('http'))
      return self.image_file_name 
    else 
    	return 'http://dogecoin.com/img/dogecoin-300.png'
    end
  end
end  
