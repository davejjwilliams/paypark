class Token < ApplicationRecord
  belongs_to :user
  def google_secret
    Google::APIClient::ClientSecrets.new(
        {:web =>
              { :access_token => access_token,
                :refresh_token => refresh_token,
                :client_id => Rails.application.credentials.google[:google_client_id],
                :client_secret => Rails.application.credentials.google[:google_client_secret],
              }
        }
    )
  end

  def expired?
    expires_at <= Time.now.to_i
  end
end
