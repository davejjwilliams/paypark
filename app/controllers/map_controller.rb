require 'google/api_client/client_secrets.rb'
require 'google/apis/calendar_v3'
class MapController < ApplicationController
  before_action :authenticate_user!

  def map
    puts "THE BOOKING SEARCH START TIME IS: #{session[:booking_start_time]}"
    puts "THE BOOKING SEARCH END TIME IS: #{session[:booking_end_time]}"
    unless  session[:booking_start_time].nil? and session[:booking_end_time].nil?
      gon.driveways = Homeowner.where("active_start < ? and active_end > ? and driveway_verified = ?", session[:booking_start_time].to_datetime, session[:booking_end_time].to_datetime, true)
    else
      gon.driveways = Homeowner.where("active_start < ? and active_end > ? and driveway_verified = ?", DateTime.now, DateTime.now, true)
    end

    puts "Current User Name is: #{current_user.email}"

    begin
      Google::Apis.logger = Logger.new(nil)
      token = current_user.google_token
      puts "Current Token Is: #{token.access_token}"
      # Initialize Google Calendar API
      service = Google::Apis::CalendarV3::CalendarService.new
      # Use google keys to authorize
      service.authorization = token.google_secret.to_authorization
      # Request for a new access token just incase it expired
      if token.expired?
        new_access_token = service.authorization.refresh!
        token.access_token = new_access_token['access_token']
        token.expires_at = Time.now.to_i + new_access_token['expires_in'].to_i
        token.save
      end

      # Fetch the next 10 events for the user
      calendar_id = "primary"
      @response = service.list_events(calendar_id, max_results: 10, single_events: true, order_by: "startTime", time_min: DateTime.now.rfc3339)
    rescue StandardError => e
      @response = "You have not given the website permissions!"
    end
  end

  def timesearch
    if params[:start_time].blank? or params[:end_time].blank?
      flash[:alert] = "Please fill in a start and end time."
      redirect_to root_path
      return
    end


    start_time = DateTime.new(params[:start_time]["start_time(1i)"].to_i, params[:start_time]["start_time(2i)"].to_i, params[:start_time]["start_time(3i)"].to_i, params[:start_time]["start_time(4i)"].to_i)
    end_time = DateTime.new(params[:end_time]["end_time(1i)"].to_i, params[:end_time]["end_time(2i)"].to_i, params[:end_time]["end_time(3i)"].to_i, params[:end_time]["end_time(4i)"].to_i)

    session[:booking_start_time] = start_time
    session[:booking_end_time] = end_time
    redirect_to root_path
  end

  def clearsearch
    session[:booking_start_time]=nil
    session[:booking_end_time]=nil
    redirect_to root_path
  end

end
