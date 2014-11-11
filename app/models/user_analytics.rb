# == Schema Information
#
# Table name: user_analytics
#
#  id              :integer          not null, primary key
#  user_identifier :string(255)
#  is_registered   :boolean
#  url             :string(255)
#  action          :integer
#  target          :string(255)
#  value           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  remember_token  :string(255)
#

class UserAnalytics < ActiveRecord::Base
  # attr_accessible :action, :is_registered, :target, :url, :user_identifier, :value, :remember_token
end
