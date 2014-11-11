# == Schema Information
#
# Table name: tickets
#
#  id              :integer          not null, primary key
#  code            :string(255)
#  transaction_id  :integer
#  created_at      :datetime
#  updated_at      :datetime
#  description     :string(255)
#  value           :integer
#  claimed         :boolean
#  event_id        :integer
#  ticket_model_id :integer
#  name            :string(255)
#

class Ticket < ActiveRecord::Base
  # attr_accessible :code, :transaction_id, :description, :value

  belongs_to :transaction
  belongs_to :event
  belongs_to :ticket_model

  before_create { set_ticket_code if self.code.blank? }

  def user
    return self.transaction.user
  end

  TICKET_CODE_NAMES = ['Freddie Mercury', 'Bob Dylan', 'Michael Jackson', 'Jimi Hendrix', 'Madonna', 'Sinatra', 'Macklemore', 'Pitbull', 'Beyonce', 'Elvis']
  TICKET_CODE_VERBS = ['flies', 'walks', 'jams', 'dances', 'performs', 'dances', 'sings']
  TICKET_CODE_PREPOSITION = ['at', 'to', 'from']
  TICKET_CODE_ARTICLE = ['a', 'the']
  TICKET_CODE_ADJECTIVE = ['dark', 'busy', 'smokey', 'crowded', 'packed']
  TICKET_CODE_PLACE = ['store', 'disco', 'bar', 'restaurant']

  def set_ticket_code
    rand_code = Ticket.get_ticket_code
    while !Ticket.find_by_code(rand_code).blank?
      rand_code = Ticket.get_ticket_code
    end
    self.code = rand_code
  end

  def post_stripe_value
    return (0.971 * self.value - 30)
  end

  def value_in_dollars
    return self.value / 100.0
  end

  def is_VIP
    return self.value > 2000
  end

  private
  def self.get_ticket_code
    return "#{ TICKET_CODE_NAMES[Random.rand(0...TICKET_CODE_NAMES.length)] } #{ TICKET_CODE_VERBS[Random.rand(0...TICKET_CODE_VERBS.length)] } #{ TICKET_CODE_PREPOSITION[Random.rand(0...TICKET_CODE_PREPOSITION.length)] } #{ TICKET_CODE_ARTICLE[Random.rand(0...TICKET_CODE_ARTICLE.length)] } #{ TICKET_CODE_ADJECTIVE[Random.rand(0...TICKET_CODE_ADJECTIVE.length)] } #{ TICKET_CODE_PLACE[Random.rand(0...TICKET_CODE_PLACE.length)] }"
  end
end
