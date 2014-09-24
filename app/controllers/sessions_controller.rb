class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:user][:email])
    if user && user.authenticate(params[:user][:password])
      s = Session.new(user_id: user.id)
      s.save_with_session_code
      cookies.permanent[:session_code] = s.session_code
      redirect_to user
    else
      render text: 'Email or passowrd inccorect'
    end
  end

  def destroy
    cookies.destroy :session_code
    redirect_to '/'
  end

end
