include UsersHelper
class EventsController < ApplicationController

  def before
    # redirect_to 'https://www.tunetap.com/dylanowen/events/ithaca' if !request.ssl?
    @current_user = current_user
    @attendees = Attendee.where('event_id=1')
    @facebook_friends_attending = []
    @non_facebook_friends_attending = []
    friends_list = (cookies[:fb_friends_attending].blank?) ? [] : cookies[:fb_friends_attending].split(',')
    @vip_count = 0
    @is_backer = false
    if !@current_user.blank?
      @attendees.each do |a|
        u = a.user
        if u.blank?
          puts "Events:14 =============================="
          puts "u is blank, attendee: #{ a.id }"
          next
        end
        @is_backer = a.id < 51 && u.id == current_user.id
        next if u.id == @current_user.id
        if friends_list.include? u.id
          @facebook_friends_attending << u
        else
          @non_facebook_friends_attending << u
        end

        trans = u.transactions
        tickets = trans.map(&:tickets).flatten()
        tickets.each do |t|
          @vip_count = @vip_count + 1 if t.is_VIP
        end
      end
    else
      @non_facebook_friends_attending = @attendees.map(&:user)
    end
    @attendee_count = @attendees.count
    @friend_count = @facebook_friends_attending.count

    @raised = 0
    @gross_raised = 0
    @ticket_count = 0
    @attendees.map(&:user).each do |u|
      if u.blank?
        puts "Events:36 =============================="
        puts "u is blank"
        next
      end
      trans = u.transactions
      tickets = trans.map(&:tickets).flatten()
      tickets.each do |t|
        @raised = @raised + (t.post_stripe_value / 100.0)
        @gross_raised = @gross_raised + t.value_in_dollars
        @ticket_count = @ticket_count + 1
      end
    end
    @percent_funded = (@raised / 500 * 100).round(0)
    @raised = @raised.round(0)

    @my_ticket_count = @current_user.tickets.count if !@current_user.blank?

    # @effective_ticket_count = (@gross_raised / 500.0 * 52.0).round
  end
  
  def after
    #redirect_to 'https://www.tunetap.com/dylanowen/events/after'

    @current_user = current_user

    @attendees = Attendee.where('event_id=1')
    @facebook_friends_attending = []
    @non_facebook_friends_attending = []
    friends_list = (cookies[:fb_friends_attending].blank?) ? [] : cookies[:fb_friends_attending].split(',')
    @vip_count = 0
    @is_backer = false
    if !@current_user.blank?
      @attendees.each do |a|
        u = a.user
        if u.blank?
          puts "Events:14 =============================="
          puts "u is blank, attendee: #{ a.id }"
          next
        end
        @is_backer = a.id < 51 && u.id == current_user.id
        next if u.id == @current_user.id
        if friends_list.include? u.id
          @facebook_friends_attending << u
        else
          @non_facebook_friends_attending << u
        end

        trans = u.transactions
        tickets = trans.map(&:tickets).flatten()
        tickets.each do |t|
          @vip_count = @vip_count + 1 if t.is_VIP
        end
      end
    else
      @non_facebook_friends_attending = @attendees.map(&:user)
    end
    @attendee_count = @attendees.count
    @friend_count = @facebook_friends_attending.count

    @raised = 0
    @gross_raised = 0
    @ticket_count = 0
    @attendees.map(&:user).each do |u|
      if u.blank?
        puts "Events:36 =============================="
        puts "u is blank"
        next
      end
      trans = u.transactions
      tickets = trans.map(&:tickets).flatten()
      tickets.each do |t|
        @raised = @raised + (t.post_stripe_value / 100.0)
        @gross_raised = @gross_raised + t.value_in_dollars
        @ticket_count = @ticket_count + 1
      end
    end
    @percent_funded = (@raised / 500 * 100).round(0)
    @raised = @raised.round(0)

    @my_ticket_count = @current_user.tickets.count if !@current_user.blank?

    # @effective_ticket_count = (@gross_raised / 500.0 * 52.0).round
  end


  def ithaca
    # redirect_to 'https://www.tunetap.com/dylanowen/events/ithaca' if !request.ssl?
    @current_user = current_user
    @attendees = Attendee.where('event_id=1')
    @facebook_friends_attending = []
    @non_facebook_friends_attending = []
    friends_list = (cookies[:fb_friends_attending].blank?) ? [] : cookies[:fb_friends_attending].split(',')
    @vip_count = 0
    @is_backer = false
    if !@current_user.blank?
      @attendees.each do |a|
        u = a.user
        if u.blank?
          puts "Events:14 =============================="
          puts "u is blank, attendee: #{ a.id }"
          next
        end
        @is_backer = a.id < 51 && u.id == current_user.id
        next if u.id == @current_user.id
        if friends_list.include? u.id
          @facebook_friends_attending << u
        else
          @non_facebook_friends_attending << u
        end

        trans = u.transactions
        tickets = trans.map(&:tickets).flatten()
        tickets.each do |t|
          @vip_count = @vip_count + 1 if t.is_VIP
        end
      end
    else
      @non_facebook_friends_attending = @attendees.map(&:user)
    end
    @attendee_count = @attendees.count
    @friend_count = @facebook_friends_attending.count

    @raised = 0
    @gross_raised = 0
    @ticket_count = 0
    @attendees.map(&:user).each do |u|
      if u.blank?
        puts "Events:36 =============================="
        puts "u is blank"
        next
      end
      trans = u.transactions
      tickets = trans.map(&:tickets).flatten()
      tickets.each do |t|
        @raised = @raised + (t.post_stripe_value / 100.0)
        @gross_raised = @gross_raised + t.value_in_dollars
        @ticket_count = @ticket_count + 1
      end
    end
    @percent_funded = (@raised / 500 * 100).round(0)
    @raised = @raised.round(0)

    @my_ticket_count = @current_user.tickets.count if !@current_user.blank?

    # @effective_ticket_count = (@gross_raised / 500.0 * 52.0).round
  end


  def show
    id = params[:id].to_i
    
    @current_user = current_user
    if @current_user.blank?
      @my_ticket_count = 0
    else
      @my_ticket_count = @current_user.tickets.count
    end

    @vip_count = 0
    @event = Event.find_by_id(id)
    pf, raised = @event.percent_funded_raised
    @percent_funded = pf.round(0)

    @facebook_friends_attending = []
    @non_facebook_friends_attending = []
    
    @artist = @event.artist

    @date = @event.venue_date.date
    @venue =  @event.venue_date.venue

    @percent_capacity = @event.tickets.count * 100.0 / @venue.capacity
    @percent_capacity = @percent_capacity.round(0)
    

    @tickets_left = (@event.goal - raised + 0.0) / @event.ticket_models[0].post_stripe_value
    @tickets_left = @tickets_left.ceil

    @ticket_models = @event.ticket_models
    
    if pf < 100
      render 'before'
    else
      render 'after'
    end

    

  end
end
