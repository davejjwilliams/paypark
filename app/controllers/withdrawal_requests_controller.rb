class WithdrawalRequestsController < ApplicationController
  before_action :set_withdrawal_request, only: [:show, :edit, :update, :destroy]

  # GET /withdrawal_requests
  # GET /withdrawal_requests.json
  def index
    @withdrawal_requests = WithdrawalRequest.all
  end

  # POST /withdraw
  def withdraw
    # create new withdrawal
    withdrawal = WithdrawalRequest.new
    withdrawal.homeowner_id = params[:homeowner_id]
    withdrawal.request_date = Time.now

    homeowner = Homeowner.find(params[:homeowner_id])
    complete_not_withdrawn_bookings = Booking.where(homeowner_id: homeowner.id, complete: true, withdrawn: false)

    amount = 0
    # for each complete booking, set withdrawn status to true and add price to amount sum
    complete_not_withdrawn_bookings.each do |booking|
      amount += booking.price
      booking.withdrawn = true
      booking.save!
    end

    withdrawal.amount = amount
    withdrawal.save!
    redirect_to homeowner_bookings_path
  end

  # GET /withdrawal_requests/1
  # GET /withdrawal_requests/1.json
  def show
  end

  # GET /withdrawal_requests/new
  def new
    @withdrawal_request = WithdrawalRequest.new
  end

  # GET /withdrawal_requests/1/edit
  def edit
  end

  # POST /withdrawal_requests
  # POST /withdrawal_requests.json
  def create
    @withdrawal_request = WithdrawalRequest.new(withdrawal_request_params)

    respond_to do |format|
      if @withdrawal_request.save
        format.html { redirect_to @withdrawal_request, notice: 'Withdrawal request was successfully created.' }
        format.json { render :show, status: :created, location: @withdrawal_request }
      else
        format.html { render :new }
        format.json { render json: @withdrawal_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /withdrawal_requests/1
  # PATCH/PUT /withdrawal_requests/1.json
  def update
    respond_to do |format|
      if @withdrawal_request.update(withdrawal_request_params)
        format.html { redirect_to @withdrawal_request, notice: 'Withdrawal request was successfully updated.' }
        format.json { render :show, status: :ok, location: @withdrawal_request }
      else
        format.html { render :edit }
        format.json { render json: @withdrawal_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /withdrawal_requests/1
  # DELETE /withdrawal_requests/1.json
  def destroy
    @withdrawal_request.destroy
    respond_to do |format|
      format.html { redirect_to withdrawal_requests_url, notice: 'Withdrawal request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_withdrawal_request
      @withdrawal_request = WithdrawalRequest.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def withdrawal_request_params
      params.require(:withdrawal_request).permit(:homeowner_id, :amount, :request_date)
    end
end
