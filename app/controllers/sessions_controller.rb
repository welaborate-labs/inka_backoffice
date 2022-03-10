class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create failure]

  def new; end

  def create
    user = User.from_omniauth(request.env['omniauth.auth'])
    session[:user_id] = user.id
    redirect_to root_url, notice: 'Signed in!'
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'Signed out!'
  end

  def failure
    redirect_to root_url, alert: 'Authentication failed, please try again.'
  end
end
