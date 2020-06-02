require 'test_helper'

class BookingTest < ActiveSupport::TestCase

  setup do
    @homeowner = homeowners(:adminhomeowner)
    @driver = drivers(:driverone)
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

  test "Should not create booking with missing start or end time" do
    # No start time
    booking = Booking.new

    booking.driver_id = @driver.id
    booking.homeowner_id = @homeowner.id
    booking.price = 9.99
    booking.end_time = DateTime.now - 2.hours
    booking.complete = false
    booking.withdrawn = false

    booking.save

    # No end time
    assert booking.invalid?

    booking1 = Booking.new

    booking1.driver_id = @driver.id
    booking1.homeowner_id = @homeowner.id
    booking1.price = 9.99
    booking1.start_time = DateTime.now - 3.hours
    booking1.complete = false
    booking1.withdrawn = false

    booking1.save

    assert booking1.invalid?
  end

  test "Should not create booking with invalid price" do

    booking = Booking.new

    booking.driver_id = @driver.id
    booking.homeowner_id = @homeowner.id
    booking.price = -9.99
    booking.start_time = DateTime.now - 3.hours
    booking.end_time = DateTime.now - 2.hours
    booking.complete = false
    booking.withdrawn = false

    booking.save

    assert booking.invalid?

  end


end
