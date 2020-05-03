class ChargesController < ApplicationController

  def create

    @booking = Booking.find(params[:booking_id])

    key
    @session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: [{
                         name: @booking.homeowner.address,
                         description: "From: " + Time.parse(@booking.start_time.to_s).strftime('%F %T %z') + " Until: " + Time.parse(@booking.end_time.to_s).strftime('%F %T %z'),
                         amount: 100,
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

    if (session[:product_id] == 0)
      flash[:notice] = "Something went wrong!"
      redirect_to root_path
      return
    end

    booking = Booking.find(session[:booking_id])

    if (@payment_intent.charges.data[0].paid)
      # booking is paid for
      # booking.paid = true
      # booking.payment_intent = @payment_intent.id
      # booking.save
    else
      # booking is not paid for
      # booking.paid = false
      # booking.save
    end

    session[:product_id] = 0
    redirect_to booking

    # if (@payment_intent.charges.data[0].paid)
    #   product = Product.find(session[:product_id])
    #   purchase = Purchase.new
    #   purchase.user_id = current_user.id
    #   purchase.product_id = product.id
    #   purchase.payment_intent = @payment_intent.id
    #   purchase.save!
    #   session[:product_id] = 0
    # else
    #   session[:product_id] = 0
    #   redirect_to charges_cancel_url
    # end
  end

  def cancel

  end

  private
    def key
      Stripe.api_key = Rails.application.credentials.stripe[:stripe_secret_key]
    end
end
