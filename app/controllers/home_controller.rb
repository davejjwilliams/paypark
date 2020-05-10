class HomeController < ApplicationController
  def contact
  end

  def booking_error
  end

  def omniauth
    @user = User.from_omniauth(auth)

    # Find token
    token = @user.tokens.find_or_initialize_by(provider: 'google')
    # Access_token is used to authenticate requests
    token.access_token = auth.credentials.token
    token.expires_at = auth.credentials.expires_at
    puts "ACCESS TOKEN EXPIRES IN #{token.expires_at}"
    # Refresh_token to request new access_token
    # Note: Refresh_token is only sent once during the first request
    refresh_token = auth.credentials.refresh_token
    token.refresh_token = refresh_token if refresh_token.present?
    # save token
    token.save

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
