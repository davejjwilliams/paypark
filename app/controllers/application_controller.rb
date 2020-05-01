class ApplicationController < ActionController::Base
  before_action :setUser
  def setUser
    if user_signed_in?
      gon.user = current_user.name
    else
      gon.user = ""
    end
  end
end
