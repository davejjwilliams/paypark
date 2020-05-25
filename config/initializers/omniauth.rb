Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, Rails.application.credentials.google[:google_client_id], Rails.application.credentials.google[:google_client_secret], prompt: "consent", scope: "userinfo.email, userinfo.profile, calendar", skip_jwt: true
end