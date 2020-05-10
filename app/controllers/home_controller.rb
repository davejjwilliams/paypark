class HomeController < ApplicationController
  def home
  end

  def contact
  end

  def request_contact
   name = params[:name]
   email = params[:email]
   telephone = params[:telephone]
   message = params[:message]

   if email.blank? or name.blank? or telephone.blank?
    flash[:alert] = I18n.t('home.request_contact.no_email')



    else
     # Send an email
     ContactMailer.contact_email(email, name, telephone, message).deliver_now
     flash[:notice] = I18n.t('home.request_contact.email_sent')
    end

     redirect_to contact_path
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
      #UserMailer.signup_confirmation(@user).deliver_now
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
