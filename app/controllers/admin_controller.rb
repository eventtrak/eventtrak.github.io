class AdminController < ApplicationController
  def login
    @total_signups = User.count
    last_visit = DateTime.parse(cookies[:last_visit])
    cookies[:last_visit] = DateTime.now.to_s
    @since_last = User.where("created_at > ?", last_visit).count
  end

  def logout
    cookies.delete :current_user
    cookies.delete :current_artist

    redirect_to :root
  end
end
