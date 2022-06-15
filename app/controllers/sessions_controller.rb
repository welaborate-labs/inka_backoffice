class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create failure]

  def new; end

  def create
    @user = User.find_or_create_from_hash(auth_hash)
    return failure if !@user

    if signed_in?
      if @user
        flash[:notice] = 'Você já está logado(a).'
      else
        redirect_to root_path, alert: 'Alguma coisa deu errado, por favor tente novamente.' and return
      end
    else
      if @user
        current_user = @user
        session[:user_id] = @user.id
        flash[:notice] = 'Logado(a)!'
      else
        redirect_to root_path, alert: 'Usuário já esta registrado.' and return
      end
    end

    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_url, notice: 'Deslogado(a).'
  end

  def failure
    redirect_to login_url, alert: 'Email ou Senha está incorreto.'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
