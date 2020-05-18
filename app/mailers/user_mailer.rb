class UserMailer < ApplicationMailer

  def signup_confirmation(user)
    @user = user
    mail to: user.email, subject: "sign up confirmation"
  end



end
