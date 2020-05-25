require 'google/api_client/client_secrets.rb'
require 'google/apis/calendar_v3'
class ChargesController < ApplicationController

  def success
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)

    if (session[:booking_id] == 0)
      flash[:notice] = "Something went wrong!"
      redirect_to root_path
      return
    end

    booking = Booking.find(session[:booking_id])

    if (@payment_intent.charges.data[0].paid)
      # booking is paid for

      begin
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
        puts "\n\n\n\nTEST DATE: #{booking.start_time.utc.iso8601}\n\n\n\n"
        event = Google::Apis::CalendarV3::Event.new(
            summary: 'PayPark Booking',
            location: booking.homeowner.address,
            description: "Parking reservation from #{booking.start_time} until #{booking.end_time} at #{booking.homeowner.address}",
            start: Google::Apis::CalendarV3::EventDateTime.new(
                date_time: booking.start_time.utc.rfc3339,
                time_zone: 'Europe/London'
            ),
            end: Google::Apis::CalendarV3::EventDateTime.new(
                date_time: booking.end_time.utc.rfc3339,
                time_zone: 'Europe/London'
            )
        )

        result = service.insert_event('primary', event)
        puts "Event summary is: #{event.summary}"
        puts "Event created: #{result.html_link}"
        puts "The Calendar Event ID is #{(Base64.decode64(result.html_link[42..-1])).split.first}"

        booking.calendar_event_id = (Base64.decode64(result.html_link[42..-1])).split.first
      rescue StandardError => e
        booking.calendar_event_id = "No Event ID"
      end
      booking.paid = true
      booking.payment_intent = @payment_intent.id
      booking.save
    else
      # booking is not paid for
      booking.destroy!
    end

    session[:booking_id] = 0
    redirect_to booking
  end

  def cancel
    if session[:booking_id] != 0
      booking = Booking.find(session[:booking_id])
      booking.destroy!
      session[:booking_id] = 0
    end
    redirect_to root_path
  end

  def refund
    # find booking through button POST params
    booking = Booking.find(params[:booking_id])

    # issue stripe refund
    refund = Stripe::Refund.create({
                                       payment_intent: booking.payment_intent,
                                   })

    unless booking.calendar_event_id == "No Event ID"
      token = current_user.google_token
      puts "Current Token Is: #{token.access_token}"
      # Initialize Google Calendar API
      service = Google::Apis::CalendarV3::CalendarService.new
      # Use google keys to authorize
      service.authorization = token.google_secret.to_authorization
      # Request for a new access token just in case it expired
      if token.expired?
        new_access_token = service.authorization.refresh!
        token.access_token = new_access_token['access_token']
        token.expires_at = Time.now.to_i + new_access_token['expires_in'].to_i
        token.save
      end

      service.delete_event('primary', booking.calendar_event_id)
    end

    # destroy booking
    booking.destroy!
    redirect_to root_path
  end

  private
    def key
      Stripe.api_key = Rails.application.credentials.stripe[:stripe_secret_key]
    end
end
