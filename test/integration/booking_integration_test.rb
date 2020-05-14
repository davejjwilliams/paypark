require "test_helper"

class BookingIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    @homeowner = homeowners(:one)
    @driver = drivers(:one)
  end

  test "invalid_booking_redirect" do

    post bookings_url, params: { booking: {
        complete: false,
        driver_id: @driver.id,
        start_time: DateTime.new(2000,05,01,12,00,00),
        homeowner_id: @homeowner.id,
        price: 50,
        end_time: DateTime.new(2020,05,01,12,00,00),
        withdrawn: false } }

    follow_redirect!
    assert_equal '/booking_error', path

  end
end
