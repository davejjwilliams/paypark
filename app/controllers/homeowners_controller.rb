class HomeownersController < ApplicationController
  before_action :set_homeowner, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /homeowners
  # GET /homeowners.json
  def index
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
        format.html { redirect_to @homeowner, notice: 'Homeowner was successfully updated.' }
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
    # Use callbacks to share common setup or constraints between actions.
    def set_homeowner
      @homeowner = Homeowner.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def homeowner_params
      params.require(:homeowner).permit(:user_id, :address, :latitude, :longitude, :driveway_description, :driveway_price, :driveway_active, :last_modified, :activation_code, :driveway_verified, :total_ratings, :number_ratings)
    end
end
