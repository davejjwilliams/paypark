class ChargesController < ApplicationController

  def create

    @booking = Booking.find(params[:booking_id])

    key
    @session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: [{
                         name: @booking.homeowner.address,
                         description: "From: " + Time.parse(@booking.start_time.to_s).strftime('%F %T %z') + " Until: " + Time.parse(@booking.end_time.to_s).strftime('%F %T %z'),
                         amount: (@booking.price*100).to_i,
                         currency: 'gbp',
                         quantity: 1,
                     }],
        success_url: charges_success_url + "?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: charges_cancel_url,
        )

    if @booking.nil?
      redirect_to root_path
      return
    end

    respond_to do |format|
      format.js #render create.js.erb
    end
  end

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
      booking.paid = false
      booking.save
    end

    session[:product_id] = 0
    redirect_to booking
  end

  def cancel

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
