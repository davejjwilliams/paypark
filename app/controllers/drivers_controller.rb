class DriversController < ApplicationController
  before_action :set_driver, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :correct_driver_check, only: [:show, :edit, :update]

  # GET /drivers
  # GET /drivers.json
  def index
    admin_check
    @drivers = Driver.all
  end

  # GET /drivers/1
  # GET /drivers/1.json
  def show
  end

  # GET /drivers/new
  def new
    if Driver.exists?(user_id: current_user.id)
      @driver = Driver.find_by_user_id(current_user.id)
      redirect_to "/drivers/#{@driver.id}", notice: "You are already registered as a driver!"
    end
    @driver = Driver.new
  end

  # GET /drivers/1/edit
  def edit
  end

  # POST /drivers
  # POST /drivers.json
  def create
    @driver = Driver.new(driver_params)
    @driver.user_id = current_user.id

    url = "https://dvlasearch.appspot.com/DvlaSearch?apikey=#{Rails.application.credentials.dvla[:dvla_api_key]}&licencePlate=#{@driver.registration_number}"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    @hash = JSON.parse(response)

    if @hash.key?("make")
      @driver.car_info = @hash["colour"] + " " + @hash["make"] + " " + @hash["model"]
    else
      @driver.car_info = "Registration number not linked to vehicle!!!"
    end

    @driver.registration_number.upcase!

    respond_to do |format|
      if @driver.save
        session[:driver_id] = @driver.id
        format.html { redirect_to @driver, notice: 'Car information registered successfully!' }
        format.json { render :show, status: :created, location: @driver }
      else
        format.html { render :new }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /drivers/1
  # PATCH/PUT /drivers/1.json
  def update
    respond_to do |format|
      if @driver.update(driver_params)

        url = "https://dvlasearch.appspot.com/DvlaSearch?apikey=#{Rails.application.credentials.dvla[:dvla_api_key]}&licencePlate=#{@driver.registration_number}"
        uri = URI(url)
        response = Net::HTTP.get(uri)
        @hash = JSON.parse(response)

        if @hash.key?("make")
          @driver.car_info = @hash["colour"] + " " + @hash["make"] + " " + @hash["model"]
        else
          @driver.car_info = "Registration number not linked to vehicle."
        end

        @driver.registration_number.upcase!

        @driver.save!

        format.html { redirect_to @driver, notice: 'Details updated successfully.' }
        format.json { render :show, status: :ok, location: @driver }
      else
        format.html { render :edit }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /drivers/1
  # DELETE /drivers/1.json
  def destroy
    @driver.destroy
    session[:driver_id] = 0
    respond_to do |format|
      format.html { redirect_to drivers_url, notice: 'Driver was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def admin_check
      unless current_user.admin?
        redirect_to root_path, alert: "You do not have admin privileges!"
      end
    end

    def correct_driver_check
      unless current_user.admin?
        if Driver.exists?(user_id: current_user.id)
          if params[:id].to_i != Driver.find_by_user_id(current_user.id).id
            flash[:alert] = "You cannot access another driver's Information!"
            redirect_to root_path
            return
          end
        else
          flash[:alert] = "You are not signed up as a driver!"
          redirect_to root_path
          return
        end
      end
    end

  # Use callbacks to share common setup or constraints between actions.
  def set_driver
    @driver = Driver.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def driver_params
    params.require(:driver).permit(:user_id, :registration_number, :car_info)
  end
end
