require 'test_helper'

class BookingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @booking = bookings(:one)
    @homeowner = homeowners(:one)
    @driver = drivers(:one)
  end

  test "Should create valid booking" do

    assert_difference('Booking.count') do
      post bookings_url, params: { booking: {
        driver_id: @driver.user_id,
        homeowner_id: @homeowner.user_id,
        price: 9.99,
        start_time: DateTime.new(2021,04,27,22,03,39),
        end_time: DateTime.new(2021,04,27,23,03,39),
        complete: false,
        withdrawn: false
      } }
    end


    assert_redirected_to booking_url(Booking.last)

  end

  test "Should not create conflicting bookings" do

    assert_difference('Booking.count') do
      post bookings_url, params: { booking: {
        driver_id: @driver.user_id,
        homeowner_id: @homeowner.user_id,
        price: 9.99,
        start_time: DateTime.new(2021,05,01,14,00,00),
        end_time: DateTime.new(2021,05,01,18,00,00),
        complete: false,
        withdrawn: false
      } }
    end

    # Invalid 1
    assert_no_difference('Booking.count') do
      post bookings_url, params: { booking: {
        driver_id: @driver.user_id,
        homeowner_id: @homeowner.user_id,
        price: 9.99,
        start_time: DateTime.new(2021,05,01,12,00,00),
        end_time: DateTime.new(2021,05,01,16,00,00),
        complete: false,
        withdrawn: false
      } }
    end

    # Invalid 2
    assert_no_difference('Booking.count') do
      post bookings_url, params: { booking: {
        driver_id: @driver.user_id,
        homeowner_id: @homeowner.user_id,
        price: 9.99,
        start_time: DateTime.new(2021,05,01,16,00,00),
        end_time: DateTime.new(2021,05,01,20,00,00),
        complete: false,
        withdrawn: false
      } }
    end

    # Invalid 3
    assert_no_difference('Booking.count') do
      post bookings_url, params: { booking: {
        driver_id: @driver.user_id,
        homeowner_id: @homeowner.user_id,
        price: 9.99,
        start_time: DateTime.new(2021,05,01,12,00,00),
        end_time: DateTime.new(2021,05,01,20,00,00),
        complete: false,
        withdrawn: false
      } }
    end

    # Invalid 4
    assert_no_difference('Booking.count') do
      post bookings_url, params: { booking: {
        driver_id: @driver.user_id,
        homeowner_id: @homeowner.user_id,
        price: 9.99,
        start_time: DateTime.new(2021,05,01,15,00,00),
        end_time: DateTime.new(2021,05,01,17,00,00),
        complete: false,
        withdrawn: false
      } }
    end

    # Invalid 5
    assert_no_difference('Booking.count') do
      post bookings_url, params: { booking: {
        driver_id: @driver.user_id,
        homeowner_id: @homeowner.user_id,
        price: 9.99,
        start_time: DateTime.new(2021,05,01,12,00,00),
        end_time: DateTime.new(2021,05,01,14,00,00),
        complete: false,
        withdrawn: false
      } }
    end

  end

  test "Should not create bookings with invalid times" do

    # End date before start date
    assert_no_difference('Booking.count') do
      post bookings_url, params: { booking: {
        driver_id: @driver.user_id,
        homeowner_id: @homeowner.user_id,
        price: 9.99,
        start_time: DateTime.new(2021,05,01,12,00,00),
        end_time: DateTime.new(2021,05,01,10,00,00),
        complete: false,
        withdrawn: false
      } }
    end

    # Date expired
    assert_no_difference('Booking.count') do
      post bookings_url, params: { booking: {
        driver_id: @driver.user_id,
        homeowner_id: @homeowner.user_id,
        price: 9.99,
        start_time: DateTime.new(2000,05,01,12,00,00),
        end_time: DateTime.new(2000,05,01,16,00,00),
        complete: false,
        withdrawn: false
      } }
    end

  end

  #test "should get new" do
  #  get new_booking_url
  #  assert_response :success
  #end

  test "should show booking" do
    get booking_url(@booking)
    assert_response :success
  end

  test "should destroy booking" do
    assert_difference('Booking.count', -1) do
      delete booking_url(@booking)
    end

    assert_redirected_to bookings_url
  end
end