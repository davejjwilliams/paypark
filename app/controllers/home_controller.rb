class HomeController < ApplicationController
  def contact
  end

  def booking_error
  end

  def omniauth
    @user = User.from_omniauth(auth)
    @user.save
    session[:user_id] = @user.id
    puts "THE CURRENT USER ID IS: " + session[:user_id].to_s
    sign_in(User.find(@user.id), scope: :user)

    if Homeowner.exists?(user_id: current_user.id)
      session[:homeowner_id] = Homeowner.find_by_user_id(current_user.id).id
      puts "THE CURRENT HOMEOWNER ID IS: " + session[:homeowner_id].to_s
    end

    if Driver.exists?(user_id: current_user.id)
      session[:driver_id] = Driver.find_by_user_id(current_user.id).id
      puts "THE CURRENT DRIVER ID IS: " + session[:driver_id].to_s
    end

    if !Homeowner.exists?(user_id: current_user.id) && !Driver.exists?(user_id: current_user.id)
      redirect_to signup_path
    else
      redirect_to root_path
    end
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end
