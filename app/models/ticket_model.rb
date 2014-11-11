# == Schema Information
#
# Table name: ticket_models
#
#  id          :integer          not null, primary key
#  description :string(255)
#  value       :integer
#  created_at  :datetime
#  updated_at  :datetime
#  event_id    :integer
#  max_amount  :integer
#  name        :string(255)
#

class TicketModel < ActiveRecord::Base

  include TicketsHelper
  
  belongs_to :event

  DISCOUNT_AMOUNT = 0.9
  
  has_many :tickets

  def amount_sold
    self.tickets.count
  end
  
  def sold_out?
    amount_sold >= max_amount
  end

  def make_ticket(is_discount)
    Ticket.create(description: self.description, value: ticket_price(is_discount) * 100, 
                  claimed: false, event_id: self.event_id)
  end

  def post_stripe_value
    return (0.971 * self.value - 30)
  end

  def ticket_price(is_discount)
    if is_discount
      # round up to the nearest half-dollar
      return ceil_nearest_half(self.value * DISCOUNT_AMOUNT / 100.0) 
    else
      return ceil_nearest_half(self.value / 100.0)
    end
  end

  def format_price(is_discount)
    '$%.2f' % ticket_price(is_discount)
  end
end
