require 'google/api_client/client_secrets.rb'
require 'google/apis/calendar_v3'
class MapController < ApplicationController
  before_action :authenticate_user!

  def map
    gon.driveways = Homeowner.all.where(driveway_active: true, driveway_verified: true)

    puts "Current User Name is: #{current_user.email}"
    token = current_user.google_token
    puts "Current Token Is: #{token.access_token}"
    # Initialize Google Calendar API
    service = Google::Apis::CalendarV3::CalendarService.new
    # Use google keys to authorize
    service.authorization = token.google_secret.to_authorization
    # Request for a new access token just incase it expired
    if token.expired?
      service.authorization = Signet::OAuth2::Client.new(    { token_credential_uri: 'https://oauth2.googleapis.com/token',
                                                               access_token: current_user.google_token,
                                                               expires_at: token.expires_at,
                                                               refresh_token: token.refresh_token,
                                                               client_id: Rails.application.credentials.google[:google_client_id],
                                                               client_secret: Rails.application.credentials.google[:google_client_secret] })

      new_access_token = service.authorization.refresh!
      token.access_token = new_access_token['access_token']
      token.expires_at = Time.now.to_i + new_access_token['expires_in'].to_i
      token.save
    end

    # Fetch the next 10 events for the user
    calendar_id = "primary"
    @response = service.list_events(calendar_id, max_results: 10, single_events: true, order_by: "startTime", time_min: DateTime.now.rfc3339)
  end
end
