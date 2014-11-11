include ApplicationHelper
class StaticPagesController < ApplicationController
  def test
  end

  def home_feature
  end

  def landing
    @user = User.new
  end

  def random_string
    render json: { string: SecureRandom.urlsafe_base64 }
  end

  def error_code
    render json: { code: error_sentence }
  end

  def landing2
    @artist = Artist.new
  end

  def login
    @artist = Artist.new
  end
end
