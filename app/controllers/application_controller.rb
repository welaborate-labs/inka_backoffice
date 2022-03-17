class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :authenticate_user!
  helper_method :current_user, :logged_in?

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    else
      @current_user = nil
    end
  end

  def signed_in?
    !!current_user
  end

  def logged_in?
    if session[:user_id]
      return true
    else
      return false
    end
  end

  def authenticate_user!
    redirect_to root_path, alert: 'You are not logged in.' unless signed_in?
  end
end
