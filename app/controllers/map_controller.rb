class MapController < ApplicationController
  before_action :authenticate_user!

  def map
    gon.driveways = Homeowner.all.where(driveway_active: true, driveway_verified: true)
  end
end
