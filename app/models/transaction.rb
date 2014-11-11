# == Schema Information
#
# Table name: transactions
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  is_paid    :boolean
#  created_at :datetime
#  updated_at :datetime
#

class Transaction < ActiveRecord::Base
  # attr_accessible :is_paid, :user_id

  belongs_to :user
  has_many :tickets
end
