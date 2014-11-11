include ApplicationHelper
include UsersHelper
class TransactionsController < ApplicationController
  def create
    Stripe.api_key = "sk_live_ySMvswpYz9EXuJR6chc9LBxS"

    @user = current_user
    ticket_count = params[:quantity].to_i
    @amount = (@user.blank?) ? 1200 : 1100
    if params[:selected_package] == 'ticketVIP'
      @amount = (@user.blank?) ? 3000 : 2700
    end
    @ticket_amount = @amount
    @amount = @amount * ticket_count

    if @user.blank?
      @user = User.find_by_email(params[:email])
      user_hash = { fname: params[:fname], lname: params[:lname], email: params[:email] }
      prms = { user: user_hash }
      @user ||= create_beta_user(prms)
      save_user_to_cookie(@user)
    end
    if params[:email] != @user.email
      @user.email = params[:email]
      @user.save
    end

    # customer = (!@user.stripe_customer_token.blank?) ? @user.stripe_customer_token : (Stripe::Customer.create(
    #   email: @user.email,
    #   card: params[:stripe_token]
    # ))
    customer = Stripe::Customer.create(
      email: @user.email,
      card: params[:stripe_token]
    )
    
    curr_trans = Transaction.new(is_paid: false)
    if @user.id.blank?
      puts 'Transactions:37 ============================='
      puts 'Hackish: Creating transaction, user does not have id, creating user'
      user_hash = { fname: params[:fname], lname: params[:lname], email: params[:email] }
      prms = { user: user_hash }
      @user = create_beta_user(prms)
      save_user_to_cookie(@user)
    end
    curr_trans.user = @user
    curr_trans.save

    tickets = []
    error_msg = ''
    ticket_count.times { |c|
      curr_ticket = Ticket.new
      curr_ticket.description = "#{ params[:selected_package] }, number #{ c }"
      curr_ticket.value = @ticket_amount
      tickets << curr_ticket
    }
    attn = nil
    if !@user.blank? && !@user.id.blank?
      attn = Attendee.where("event_id=1 AND user_id=#{ @user.id }")
    end
    if attn.blank?
      attn = Attendee.new(event_id: 1)
      if @user.id.blank?
        puts 'Transactions:54 ============================='
        puts 'Hackish: Creating attendee, user does not have id, creating user'
        user_hash = { fname: params[:fname], lname: params[:lname], email: params[:email] }
        prms = { user: user_hash }
        @user = create_beta_user(prms)
        save_user_to_cookie(@user)
      end
      attn.user = @user
      attn.save
    end
    tx_word = (tickets.count > 1) ? 'tickets' : 'ticket'
    charge_description = "#{ tickets.count } #{ tx_word } for #{ @user.email }"
    error_code = ''
    begin
      Stripe::Charge.create(
        customer: customer.id,
        amount: @amount,
        description: charge_description,
        currency: 'usd'
      )
      curr_trans.is_paid = true
    rescue Stripe::CardError => e
      puts "Stripe card error: #{ e }"
      error_code = error_sentence
      error_msg = e
      curr_trans.is_paid = false
    end
    curr_trans.tickets = tickets if curr_trans.is_paid
    curr_trans.save
    
    # Save tickets to cookie
    ticket_ids = ''
    tickets.each { |t| ticket_ids << "#{ t.id } " }
    cookies[:tickets] = { value: "#{ cookies[:tickets] } #{ ticket_ids }", expires: 1.month.from_now }

    # Send ticket to current user
    tickets.each { |ticket| 
      TicketMailer.user_ticket(ticket).deliver if curr_trans.is_paid
    }

    render json: {
      error_code: error_code,
      error_msg: error_msg,
      paid: curr_trans.is_paid,
      success: true
    }

    # Save Stripe customer ID for later
    # @user.stripe_customer_token = customer.id
    # @user.save
  end
end
