class Token < ApplicationRecord
  belongs_to :user
  def google_secret
    Google::APIClient::ClientSecrets.new(
        { "web" =>
              { "access_token" => access_token,
                "refresh_token" => refresh_token,
                "client_id" => ENV['G_CLIENT_ID'],
                "client_secret" => ENV['G_CLIENT_SECRET'],
              }
        }
    )
  end
  def expired?
    expires_at <= Time.now.to_i
  end
end
