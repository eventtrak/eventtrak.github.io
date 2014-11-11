class UsersController < ApplicationController

  include UsersHelper
  
  def create_beta
    create_beta_user(params)
    
    # @user created in create_beta_user
    if @user.errors.empty?
      @success = true
    else
      @success = false
    end
    save_user_to_cookie(@user) if @success
    
    render json: {
      errors: @user.nice_messages,
      success: @success
    }
  end

  def fb_login
    fb_info = params[:fb_info]
    fb_id = fb_info[:id]
    # Try to find user with FBID in database
    # If one exists, sign in and redirect
    # If one doesn't exist, create user
    user = User.find_by_facebook_id(fb_id)
    user ||= User.find_by_email(fb_info[:email])

    if user.blank?
      user_hash = { fname: fb_info[:first_name], lname: fb_info[:last_name], email: fb_info[:email], password: temporary_password, has_temp_password: true, facebook_id: fb_id, is_artist: 0 }
      prms = { user: user_hash }
      result = create_beta_user(prms)
      if !result.blank?
        save_user_to_cookie(result)
        # redirect_to :back
      end
    else
      update_user_for_facebook_login(user, fb_info.merge(facebook_id: fb_id))
      save_user_to_cookie(user)
      # redirect_to :back
    end

    render json: {
      success: true
    }
  end

  def login
    user = User.find_by_email(params[:user][:email].downcase)
    if user && user.authenticate(params[:user][:password])
      save_user_to_cookie(user)
      # if needs_password_change(user)
      #   redirect_to pwchange_path
      # end
      render json: {
        success: true
      }
    else
      render json: {
        success: false
      }
    end
  end

  def logout
    cookies.delete :current_user
    # redirect_to :back
  end

  def update_facebook
    friends = params[:friend_list]
    if !friends.blank?
      friends.each do |f|
        fbid1 = params[:fbid]
        fbid2 = f[1][:id]
        if !FacebookFriend.find_by_fbid1_and_fbid2(fbid1, fbid2).blank? or !FacebookFriend.find_by_fbid1_and_fbid2(fbid2, fbid1).blank?
        else
          FacebookFriend.create(fbid1: fbid1, fbid2: fbid2)
        end
      end
    else puts "Friends looks blank"
    end

    render json: {
      success: 1
    }
  end

  def tickets
    @tickets = []
    curr_user = current_user
    if !curr_user.blank?
      attendees = Attendee.where('event_id=1')
      attendees.map(&:user).each do |u|
        if u.blank?
          puts "Users:98 =============================="
          puts "u is blank"
          next
        end
        next if u.id != curr_user.id
        trans = u.transactions
        tix = trans.map(&:tickets)
        @tickets << tix
      end
    end
    @tickets.flatten!
  end
  
end
