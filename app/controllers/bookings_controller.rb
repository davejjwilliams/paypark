class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :update, :destroy]
  before_action :authenticate_user!

  # GET /bookings
  # GET /bookings.json
  def index
    @bookings = Booking.all
  end

  # GET /homeowner_bookings
  def homeowner_bookings
    if Homeowner.exists?(:user_id => current_user.id)
      @homeowner = Homeowner.find_by_user_id(current_user.id)
      @upcoming_homeowner_bookings = Booking.where(homeowner_id: @homeowner.id, complete: false)
      @complete_homeowner_bookings = Booking.where(homeowner_id: @homeowner.id, complete: true)
    else
      redirect_to root_path
    end
  end

  # GET /driver_bookings
  def driver_bookings
    if Driver.exists?(:user_id => current_user.id)
      @driver = Driver.find_by_user_id(current_user.id)
      @upcoming_driver_bookings = Booking.where(driver_id: @driver.id, complete: false)
      @complete_driver_bookings = Booking.where(driver_id: @driver.id, complete: true)
    else
      redirect_to root_path
    end

  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
    session[:booking_id] = @booking.id

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
    end


  end

  # GET /bookings/new
  def new
    driver_check

    if (!params[:dvwid].nil?)
      @booking = Booking.new
      session[:current_driveway] = params[:dvwid]
      @homeowner = Homeowner.find(session[:current_driveway])
    else
      redirect_to root_path
    end

  end

  # POST /bookings
  # POST /bookings.json
  def create
    @booking = Booking.new(booking_params)

    # Ensure bookings are hourly
    @booking.start_time = @booking.start_time.change(min: 0)
    @booking.end_time = @booking.end_time.change(min: 0)

    @booking.price = @booking.homeowner.driveway_price * (@booking.end_time - @booking.start_time)/3600

    # Get all other bookings under this homeowner
    @other_bookings = Booking.where(:homeowner_id => @booking.homeowner_id)

    # Check for booking encompassing, booking being encompassed, start time overlap, and end time overlap
    @other_bookings.each do |ob|
      if (@booking.start_time >= ob.start_time && @booking.end_time <= ob.end_time) ||
        (@booking.start_time <= ob.start_time && @booking.end_time >= ob.end_time) ||
        (@booking.start_time >= ob.start_time && @booking.start_time <= ob.end_time) ||
        (@booking.end_time >= ob.start_time && @booking.end_time <= ob.end_time)
          redirect_to "/booking_error"
          return
      end
    end

    # Check that the booking time is at least an hour later than the end time, and that the booking starts before it ends
    if Time.current + 1.hour > @booking.start_time || @booking.start_time >= @booking.end_time
      redirect_to "/booking_error"
    else
      respond_to do |format|
        if @booking.save
          format.html { redirect_to @booking, notice: 'Booking was successfully created.' }
          format.json { render :show, status: :created, location: @booking }
        else
          format.html { render :new }
          format.json { render json: @booking.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /bookings/1
  # PATCH/PUT /bookings/1.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)
        # Redirect to payment
        format.html { redirect_to @booking, notice: 'Booking was successfully updated.' }
        format.json { render :show, status: :ok, location: @booking }
      else
        format.html { render :edit }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to bookings_url, notice: 'Booking was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    # Helper method to redirect non-registered driver to the driver registration page when they try to book.
    def driver_check
      if (!Driver.exists?(user_id: current_user.id))
        flash[:alert] = "You are not registered as a driver!"
        redirect_to new_driver_path
      end
    end

    # Only allow a list of trusted parameters through.
    def booking_params
      params.require(:booking).permit(:driver_id, :homeowner_id, :price, :start_time, :end_time, :complete, :withdrawn, :paid, :payment_intent)
    end
end
