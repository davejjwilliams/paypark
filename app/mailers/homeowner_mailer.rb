class HomeownerMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.homeowner_mailer.homeowner_confirmation.subject
  #
  def homeowner_confirmation(homeowner)

    @homeowner = homeowner

    mail to: homeowner.user.email, subject: "Verfication code"
  end
end
