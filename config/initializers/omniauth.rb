Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, Rails.application.credentials.google[:google_client_id], Rails.application.credentials.google[:google_client_secret], prompt: "consent", scope: "userinfo.email, userinfo.profile, calendar", skip_jwt: true
end

# Added to config/initializers/omniauth.rb
OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}