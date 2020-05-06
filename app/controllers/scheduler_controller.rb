class SchedulerController < ApplicationController
  skip_forgery_protection
  before_action :authenticate_user!

  def get
    homeowner = Homeowner.find(session[:current_driveway])
    driveway_bookings = Booking.all.where(homeowner_id: homeowner.id)

    render :json => driveway_bookings.map {|booking| {
        :id => booking.id,
        :start_date => booking.start_time.to_formatted_s(:db),
        :end_date => booking.end_time.to_formatted_s(:db),
        :text => "Event Text"
    }}
  end

  def add
    homeowner = Homeowner.find_by(session[:current_driveway])
    driver = Driver.find_by_user_id(current_user.id)
    booking = Booking.create :driver_id => driver.id, :homeowner_id => homeowner.id, :start_time=>params["start_date"], :end_time=>params["end_date"]

    render :json=>{:action => "inserted", :tid => booking.id}
  end

  def update
    booking = Booking.find(params["id"])
    booking.start_time = params["start_date"]
    booking.end_time = params["end_date"]
    booking.save

    render :json=>{:action => "updated"}
  end

  def delete
    Booking.find(params["id"]).destroy

    render :json=>{:action => "deleted"}
  end
end
