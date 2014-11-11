# -*- coding: utf-8 -*-
module UsersHelper

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  def create_beta_user(params)
    input = params[:user]
    input ||= params[:login]

    is_artist = input[:isArtist].to_i

    @user = User.new(input)
    @user.is_artist = (is_artist == 1)
    if @user.password.blank?
      @user.password = temporary_password
      @user.has_temp_password = true
    end
    @user.client_ip = request.remote_ip

    should_save = @user.valid?

    # session[:new_user] = @user.id
    if should_save && @user.save
      cookies[:landing_signup] = @user.id
    end

    return @user
  end


  def temporary_password
    return (0...16).map{ ('a'..'z').to_a[rand(26)] }.join
  end

  BAD_WORDS = %w(cunt faggot fuck fuq hoes hoez jizz nigger nigga suck sucker)
  
  def is_profane_name?(name)
    if name.blank?
      return false
    else
      n = name.downcase
    end
    BAD_WORDS.each do |t|
      if n.include? t
        return true
      end
    end
    return false
  end

  def has_facebook_id(a_user)
    return !a_user.facebook_id.nil? && a_user.facebook_id.to_i > 0   # It actually looks like facebook IDs 1–3 don't return anything
  end
  def save_user_to_cookie(a_user)
    if a_user.has_temp_password && !has_facebook_id(a_user)
      cookies[:new_user] = { value: a_user.id, expires: 20.years.from_now }
    else
      cookies[:current_user] = { value: a_user.remember_token, expires: 20.years.from_now }
    end
  end
  def update_user_for_facebook_login(a_user, input)
    # update_column to bypass validation (was getting some issues with the password not being 6 characters)
    a_user.update_column(:facebook_id, input[:facebook_id])
    a_user.save  # Trigger create_remember_token
  end

  def current_user
    if !defined?(cookies[:current_user]) || cookies[:current_user].blank?
      return nil
    else
      return User.find_by_remember_token(cookies[:current_user])
    end
  end

  def needs_password_change(a_user)
    return a_user.has_temp_password && (!defined?a_user.facebook_id || a_user.facebook_id.blank?)
  end

end
