require 'test_helper'

class BookingTest < ActiveSupport::TestCase

  setup do
    @homeowner = homeowners(:one)
    @driver = drivers(:one)
  end

  test "Should create valid booking" do

    booking = Booking.new

    booking.driver_id = @driver.user_id
    booking.homeowner_id = @homeowner.user_id
    booking.price = 9.99
    booking.start_time = DateTime.new(2021,04,27,22,03,39)
    booking.end_time = DateTime.new(2021,04,27,23,03,39)
    booking.complete = false
    booking.withdrawn = false

    booking.save

    assert booking.valid?

  end


end
