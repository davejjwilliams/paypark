require 'test_helper'

class BookingTest < ActiveSupport::TestCase

  setup do
    @user = users(:admin)
    @homeowner = homeowners(:adminhomeowner)
    @driver = drivers(:driverone)
    sign_in @user
  end

  test "Should create valid booking" do

    booking = Booking.new

    booking.driver_id = @driver.id
    booking.homeowner_id = @homeowner.id
    booking.price = 9.99
    booking.start_time = DateTime.now - 3.hours
    booking.end_time = DateTime.now - 2.hours
    booking.complete = false
    booking.withdrawn = false

    booking.save

    assert booking.valid?

  end


end
