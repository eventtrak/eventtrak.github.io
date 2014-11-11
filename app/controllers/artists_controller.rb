class ArtistsController < ApplicationController

  include ArtistsHelper
  include UsersHelper
  
  def show
    @current_artist = current_artist
    if current_artist.blank?
      current_artist = false
    else
      current_artist = true
    end
    @attendees = Attendee.where('event_id=1')
    @artist = Artist.find_by_route_name(params[:artist_route])

    if @artist.blank?
      not_found
    end
    
    @is_current_artist = is_current_artist(@artist)
    
    @events = @artist.sorted_all_events
    @raised = 0
    @attendees.map(&:user).each do |u|
      if u.blank?
        puts "Artists:7 =============================="
        puts "u is blank"
        next
      end
      trans = u.transactions
      tickets = trans.map(&:tickets).flatten(1)
      tickets.each do |t|
        @raised = @raised + (t.post_stripe_value / 100.0)
      end
    end
    @percent_funded = (@raised / 500 * 100).round()
    
  end

  def update
    @artist = Artist.find(params[:id])
    
    if not params[:artist_name].blank?
      @artist.artist_name = params[:artist_name]
    end

    if not params[:description].blank?
      @artist.description = params[:description]
    end

      @artist.youtube = params[:youtube]
      @artist.facebook = params[:facebook]
      @artist.twitter = params[:twitter]
      @artist.instagram = params[:instagram]

    @artist.save

  end

  def dylan_owen
    @attendees = Attendee.where('event_id=1')
    @raised = 0
    @attendees.map(&:user).each do |u|
      if u.blank?
        puts "Artists:7 =============================="
        puts "u is blank"
        next
      end
      trans = u.transactions
      tickets = trans.map(&:tickets).flatten(1)
      tickets.each do |t|
        @raised = @raised + (t.post_stripe_value / 100.0)
      end
    end
    @percent_funded = (@raised / 500 * 100).round()
  end

  def tone_perignon
    @attendees = Attendee.where('event_id=1')
    @raised = 0
    @attendees.map(&:user).each do |u|
      if u.blank?
        puts "Artists:25 =============================="
        puts "u is blank"
        next
      end
      trans = u.transactions
      tickets = trans.map(&:tickets).flatten(1)
      tickets.each do |t|
        @raised = @raised + (t.post_stripe_value / 100.0)
      end
    end
    @percent_funded = (@raised / 500 * 100).round()
  end

  def create
    @artist = Artist.create(artist_params)

    if @artist.errors.empty?
      @success = true
      save_artist_to_cookie(@artist)
      route = '/' + @artist.route_name
    else
      @success = false
      route = nil
    end
    # save_user_to_cookie(@artist) if @success
    
    render json: {
      errors: @artist.nice_messages,
      route: route,
      success: @success
    }
  end

  def artist_params
    puts params
    params.require(:artist).permit(:artist_name, :route_name, :password, :email)
  end

  def login
    d = params[:artist]
    @artist = Artist.find_by_email(d[:email])

    errors = []
    
    if @artist and @artist.authenticate(d[:password])
      @success = true
      save_artist_to_cookie(@artist)
      route = '/' + @artist.route_name
    else
      @success = false
      errors << 'Invalid email or password'
      route = nil
    end

    render json: {
      errors: errors,
      route: route,
      success: @success
    }    
  end
end

