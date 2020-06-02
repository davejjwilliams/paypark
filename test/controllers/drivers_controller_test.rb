require 'test_helper'

class DriversControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin)
    @driver = drivers(:admindriver)
    sign_in @user
  end

  test "should get index" do
    get drivers_url
    assert_response :success
  end

  test "should not get new for registered driver" do
    get new_driver_url

    assert_redirected_to @driver
  end

  test "should create driver" do
    assert_difference('Driver.count') do
      post drivers_url, params: { driver: { registration_number: @driver.registration_number, user_id: @user.id } }
    end

    assert_redirected_to driver_url(Driver.last)
  end

  test "should assign car info from DVLA" do
    # Testing various cases and
    assert_difference('Driver.count') do
      post drivers_url, params: { driver: { registration_number: "MT09TKC", user_id: @user.id } }
    end

    assert_redirected_to driver_url(Driver.last)
    puts "Car-Info: #{Driver.last.car_info}"
    assert Driver.last.car_info, "RED HONDA CIVIC"

    assert_difference('Driver.count') do
      post drivers_url, params: { driver: { registration_number: "mt09 nks", user_id: @user.id } }
    end

    assert_redirected_to driver_url(Driver.last)

    assert Driver.last.car_info, "SILVER VOLKSWAGEN TIGUAN"

    assert_difference('Driver.count') do
      post drivers_url, params: { driver: { registration_number: "FH51 ABK", user_id: @user.id } }
    end

    assert_redirected_to driver_url(Driver.last)

    assert Driver.last.car_info, "GREY FORD GALAXY"
  end

  test "should show driver" do
    get driver_url(@driver)
    assert_response :success
  end

  test "should get edit" do
    get edit_driver_url(@driver)
    assert_response :success
  end

  test "should update driver" do
    patch driver_url(@driver), params: { driver: { registration_number: @driver.registration_number, user_id: @driver.user_id } }
    assert_redirected_to driver_url(@driver)
  end

  test "should destroy driver" do
    assert_difference('Driver.count', -1) do
      delete driver_url(@driver)
    end

    assert_redirected_to drivers_url
  end
end
