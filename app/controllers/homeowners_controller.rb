class HomeownersController < ApplicationController
  before_action :set_homeowner, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :correct_homeowner_check, only: [:show, :edit, :update, :destroy]

  # GET /homeowners
  # GET /homeowners.json
  def index
    admin_check
    @homeowners = Homeowner.all
  end

  # GET /homeowners/1
  # GET /homeowners/1.json
  def show
  end

  # GET /homeowners/new
  def new
    if Homeowner.exists?(user_id: current_user.id)
      @homeowner = Homeowner.find_by_user_id(current_user.id)
      redirect_to "/homeowners/#{@homeowner.id}"
    end
    @homeowner = Homeowner.new
  end

  # GET /homeowners/1/edit
  def edit
    unless @homeowner.driveway_verified
      redirect_to @homeowner, notice: "Your driveway isn't verified yet!"
    end
  end

  # POST /homeowners
  # POST /homeowners.json
  def create
    @homeowner = Homeowner.new(homeowner_params)
    @homeowner.user_id = current_user.id
    @homeowner.activation_code = (0...8).map { (65 + rand(26)).chr }.join
    @homeowner.last_modified = Date.today

    respond_to do |format|
      if @homeowner.save
        HomeownerMailer.homeowner_confirmation(@homeowner).deliver_now
        session[:homeowner_id] = @homeowner.id
        format.html { redirect_to @homeowner, notice: 'Homeowner was successfully created.' }
        format.json { render :show, status: :created, location: @homeowner }
      else
        format.html { render :new }
        format.json { render json: @homeowner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /homeowners/1
  # PATCH/PUT /homeowners/1.json
  def update
    respond_to do |format|
      if @homeowner.update(homeowner_params)
        format.html { redirect_to @homeowner, notice: 'Details updated successfully.' }
        format.json { render :show, status: :ok, location: @homeowner }
      else
        format.html { render :edit }
        format.json { render json: @homeowner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /homeowners/1
  # DELETE /homeowners/1.json
  def destroy
    @homeowner.destroy
    session[:homeowner_id] = 0
    respond_to do |format|
      format.html { redirect_to homeowners_url, notice: 'Homeowner was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def admin_check
      unless current_user.admin?
        redirect_to root_path, alert: "You do not have admin privileges!"
      end
    end

    def correct_homeowner_check
      unless current_user.admin?
        if Homeowner.exists?(user_id: current_user.id)
          if params[:id].to_i != Homeowner.find_by_user_id(current_user.id).id
            flash[:alert] = "You cannot access another homeowner's Information!"
            redirect_to root_path
            return
          end
        else
          flash[:alert] = "You are not signed up as a homeowner!"
          redirect_to root_path
          return
        end
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_homeowner
      @homeowner = Homeowner.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def homeowner_params
      params.require(:homeowner).permit(:user_id, :address, :latitude, :longitude, :driveway_description, :driveway_price, :last_modified, :activation_code, :driveway_verified, :total_ratings, :number_ratings, :paypal_email, :active_start, :active_end)
    end
end
