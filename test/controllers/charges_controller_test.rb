require 'test_helper'

class ChargesControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  setup do
    @user = users(:admin)
    sign_in @user
  end

  test "Should not get success without params" do
    get charges_success_path
    assert_redirected_to root_path
  end

  test "Should redirect home if get cancel" do
    get charges_cancel_path
    assert_redirected_to root_path
  end
end
