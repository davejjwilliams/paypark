require 'test_helper'

class HomeownerTest < ActiveSupport::TestCase
  setup do
    @user = users(:admin)
    sign_in @user
  end

  test "Should create valid homeowner" do
    homeowner = Homeowner.new

    homeowner.user = @user
    homeowner.address = "Address"
    homeowner.latitude = 1.0
    homeowner.latitude = 1.0
    homeowner.driveway_description = "Description"
    homeowner.driveway_price = 10
    homeowner.paypal_email = "test@paypal.com"

    homeowner.save

    assert homeowner.valid?
  end

  test "Should not create homeowner with invalid fields" do
    # Missing address
    homeowner = Homeowner.new

    homeowner.user = @user
    homeowner.latitude = 1.0
    homeowner.latitude = 1.0
    homeowner.driveway_description = "Description"
    homeowner.driveway_price = 10
    homeowner.paypal_email = "test@paypal.com"

    homeowner.save

    assert homeowner.invalid?

    # Missing price
    homeowner1 = Homeowner.new

    homeowner1.user = @user
    homeowner1.address = "Address"
    homeowner1.latitude = 1.0
    homeowner1.latitude = 1.0
    homeowner1.driveway_description = "Description"
    homeowner1.paypal_email = "test@paypal.com"

    homeowner1.save

    assert homeowner1.invalid?

    # Missing description
    homeowner2 = Homeowner.new

    homeowner2.user = @user
    homeowner2.address = "Address"
    homeowner2.latitude = 1.0
    homeowner2.latitude = 1.0
    homeowner2.driveway_price = 10
    homeowner2.paypal_email = "test@paypal.com"

    homeowner2.save

    assert homeowner2.invalid?

    # Missing paypal email
    homeowner3 = Homeowner.new

    homeowner3.user = @user
    homeowner3.address = "Address"
    homeowner3.latitude = 1.0
    homeowner3.latitude = 1.0
    homeowner3.driveway_description = "Description"
    homeowner3.driveway_price = 10

    homeowner3.save

    assert homeowner3.invalid?
  end

  test "Should not create homeowner with matching address" do
    homeowner = Homeowner.new

    homeowner.user = @user
    homeowner.address = "Address"
    homeowner.latitude = 1.0
    homeowner.latitude = 1.0
    homeowner.driveway_description = "Description"
    homeowner.driveway_price = 10
    homeowner.paypal_email = "test@paypal.com"

    homeowner.save

    assert homeowner.valid?

    homeowner2 = Homeowner.new

    homeowner2.user = @user
    homeowner2.address = "Address"
    homeowner2.latitude = 1.0
    homeowner2.latitude = 1.0
    homeowner2.driveway_description = "Description"
    homeowner2.driveway_price = 10
    homeowner2.paypal_email = "test@paypal.com"

    homeowner2.save

    assert homeowner2.invalid?
  end

  # test "Should create valid booking" do
  #
  #   booking = Booking.new
  #
  #   booking.driver_id = @driver.id
  #   booking.homeowner_id = @homeowner.id
  #   booking.price = 9.99
  #   booking.start_time = DateTime.now - 3.hours
  #   booking.end_time = DateTime.now - 2.hours
  #   booking.complete = false
  #   booking.withdrawn = false
  #
  #   booking.save
  #
  #   assert booking.valid?
  #
  # end

end
