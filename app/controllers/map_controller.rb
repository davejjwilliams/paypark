class MapController < ApplicationController
  before_action :authenticate_user!

  def map
    gon.driveways = Homeowner.all
  end
end
