class TicketsController < ApplicationController
  def redeem
  end

  def check_code
    t = Ticket.find_by_code(params[:code])
    status_string = ''
    status_success = 1
    if t.blank?
      status_string = "Couldn't find a ticket with that code"
      status_success = 0
    else
      status_string = "Ticket number #{ t.id } was bought by #{ t.user.display_name } and is available!"
      if t.claimed
        status_string = "That ticket has already been used"
        status_success = 0
      end
    end

    render json: { status: status_success, string: status_string }
  end

  def claim
    t = Ticket.find_by_code(params[:code])
    status_string = ''
    status_success = 1
    if t.blank?
      status_string = "Couldn't find a ticket with that code"
      status_success = 0
    else
      t.claimed = true
      t.save
      status_string = "SUCCESS: Ticket number #{ t.id } to #{ t.user.display_name } has been claimed"
      status_success = 1
    end

    render json: { status: status_success, string: status_string }
  end
end
