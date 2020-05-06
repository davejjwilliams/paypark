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

    # destroy booking
    booking.destroy!
    redirect_to root_path
  end

  private
    def key
      Stripe.api_key = Rails.application.credentials.stripe[:stripe_secret_key]
    end
end
