class VenuesController < ApplicationController
  def index
    @locationinput = params[:location]
    @nameinput = params[:name]
    @maxcapinput = params[:maxcapacity]
    
    currpage = params[:page] || 1


    if @locationinput.blank? && @nameinput.blank? && @maxcapinput.blank?
      @select_venues = Venue.limit(24).offset((currpage.to_i-1)*24)
    elsif !(@locationinput.blank?) && @nameinput.blank? && @maxcapinput.blank?
      @select_venues = Venue.where(["city LIKE (?)", "%#{@locationinput}%"]) 
    elsif @locationinput.blank? && !(@nameinput.blank?) && @maxcapinput.blank?
      @select_venues = Venue.where(["name LIKE (?)", "%#{@nameinput}%"]) 
    elsif @locationinput.blank? && @nameinput.blank? && !(@maxcapinput.blank?)
      @select_venues = Venue.where(["capacity BETWEEN (?) AND (?)", "#{@maxcapinput.to_i*0.8}", "#{@maxcapinput.to_i*1.2}"])
    elsif !(@locationinput.blank?) && !(@nameinput.blank?)&& @maxcapinput.blank?
      @select_venues = Venue.where(["city LIKE (?) AND name LIKE (?)", "%#{@locationinput}%", "%#{@nameinput}%"])
    elsif !(@locationinput.blank?) && @nameinput.blank? && !(@maxcapinput.blank?)
      @select_venues = Venue.where(["city LIKE (?) AND capacity BETWEEN (?) AND (?)", "%#{@locationinput}%", "#{@maxcapinput.to_i*0.8}", "#{@maxcapinput.to_i*1.2}"])
    elsif @locationinput.blank? && !(@nameinput.blank?) && !(@maxcapinput.blank?)
      @select_venues = Venue.where(["name LIKE (?) AND capacity BETWEEN (?) AND (?)", "%#{@nameinput}%", "#{@maxcapinput.to_i*0.8}", "#{@maxcapinput.to_i*1.2}"])
    elsif !(@locationinput.blank?) && !(@nameinput.blank?) && !(@maxcapinput.blank?)
      @select_venues = Venue.where(["city LIKE (?) AND name LIKE (?) AND capacity BETWEEN (?) AND (?)", "%#{@locationinput}%", "%#{@nameinput}%", "#{@maxcapinput.to_i*0.8}", "#{@maxcapinput.to_i*1.2}"])
    end

    respond_to do |format|
      format.html { render 'index' }
      format.json { render json: @select_venues }
    end
  end

  def show
    @venue = Venue.find(params[:id])
  end

  def new
  end

  def start
    input = params[:contact]
    success = input.blank? ? -1 : 1
    if input.include? '@'
      # http://stackoverflow.com/a/4770173/472768
      success = -1 if !input.match /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i
    else
      i = input.gsub(/[^0-9]/, '')
      # http://stackoverflow.com/a/123666/472768
      success = -1 if i.length != 10
    end
    SignupMailer.new_signup(input).deliver if success == 1
    render json: { success: success }
  end
end
