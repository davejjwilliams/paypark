class HomeController < ApplicationController
  def home
  end

  def contact
  end

  def omniauth
    @user = User.from_omniauth(auth)
    @user.save
    session[:user_id] = @user.id
    sign_in(User.find(@user.id), scope: :user)
    redirect_to map_path
  end

  private
  def auth
    request.env['omniauth.auth']
  end
end
