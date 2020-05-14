# Preview all emails at http://localhost:3000/rails/mailers/homeowner_mailer
class HomeownerMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/homeowner_mailer/homeowner_confirmation
  def homeowner_confirmation
    HomeownerMailer.homeowner_confirmation
  end

end
