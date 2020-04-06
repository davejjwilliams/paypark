class VerificationController < ApplicationController
  before_action :authenticate_user!

  def verify
    @homeowner = Homeowner.find_by_user_id(current_user.id)
    code_from_form = params['myform']['code']

    if code_from_form == @homeowner.activation_code
      @homeowner.driveway_verified = true
      @homeowner.save
      redirect_to "/homeowners/#{@homeowner.id}"
    else
      redirect_to root_path
    end
  end

  def new
    @homeowner = Homeowner.find_by_user_id(current_user.id)
    if @homeowner.driveway_verified == true
      redirect_to "/homeowners/#{@homeowner.id}"
    end
  end
end
