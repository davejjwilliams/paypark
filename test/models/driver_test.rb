require 'test_helper'

class DriverTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  setup do
    @user = users(:admin)
  end

  test "Should create valid driver" do
    driver = Driver.new

    driver.user = @user
    driver.registration_number = "Test"
    driver.car_info = "Test"

    driver.save

    assert driver.valid?
  end

  test "Should not create invalid driver" do
    # Missing registration number
    driver = Driver.new

    driver.user = @user
    driver.car_info = "Test"

    driver.save

    assert driver.invalid?

    # Missing car info
    driver1 = Driver.new

    driver1.user = @user
    driver1.registration_number = "Test"

    driver1.save

    assert driver1.invalid?
  end

end
