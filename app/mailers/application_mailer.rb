class ApplicationMailer < ActionMailer::Base
  default to: "payparkmailer@gmail.com", from: 'payparkmailer@gmail.com'
  layout 'mailer'
end
