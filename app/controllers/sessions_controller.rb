class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create failure]

  def new; end

  def create
    @user = User.find_or_create_from_hash(auth_hash)
    return failure if !@user

    if signed_in?
      if @user
        flash[:notice] = 'You are already logged in.'
      else
        redirect_to root_path, alert: 'Something is wrong, please try again.' and return
      end
    else
      if @user
        current_user = @user
        session[:user_id] = @user.id
        flash[:notice] = 'Signed in!'
      else
        redirect_to root_path, alert: 'User already registered.' and return
      end
    end

    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_url, notice: 'Signed out!'
  end

  def failure
    redirect_to login_url, alert: 'Email or Password incorrect.'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
