module ArtistsHelper

  def save_artist_to_cookie(a)
    cookies[:current_artist] = {
      value: a.remember_token,
      expires: 20.years.from_now
    }
  end

  def current_artist
    if !defined?(cookies[:current_artist]) || cookies[:current_artist].blank?
      return nil
    else
      return Artist.find_by_remember_token(cookies[:current_artist])
    end
  end

  def is_current_artist(artist)
    !artist.remember_token.blank? and artist.remember_token == cookies[:current_artist]
  end

end

