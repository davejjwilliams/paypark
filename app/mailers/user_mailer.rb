class UserMailer < ApplicationMailer

  def signup_confirmation(user)
    @user = user
    mail to: user.email, subject: "Welcome to PayPark"
  end



end
