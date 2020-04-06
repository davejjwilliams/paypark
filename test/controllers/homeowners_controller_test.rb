require 'test_helper'

class HomeownersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @homeowner = homeowners(:one)
  end

  test "should get index" do
    get homeowners_url
    assert_response :success
  end

  test "should get new" do
    get new_homeowner_url
    assert_response :success
  end

  test "should create homeowner" do
    assert_difference('Homeowner.count') do
      post homeowners_url, params: { homeowner: { activation_code: @homeowner.activation_code, address: @homeowner.address, driveway_active: @homeowner.driveway_active, driveway_description: @homeowner.driveway_description, driveway_price: @homeowner.driveway_price, driveway_verified: @homeowner.driveway_verified, last_modified: @homeowner.last_modified, latitude: @homeowner.latitude, longitude: @homeowner.longitude, number_ratings: @homeowner.number_ratings, total_ratings: @homeowner.total_ratings, user_id: @homeowner.user_id } }
    end

    assert_redirected_to homeowner_url(Homeowner.last)
  end

  test "should show homeowner" do
    get homeowner_url(@homeowner)
    assert_response :success
  end

  test "should get edit" do
    get edit_homeowner_url(@homeowner)
    assert_response :success
  end

  test "should update homeowner" do
    patch homeowner_url(@homeowner), params: { homeowner: { activation_code: @homeowner.activation_code, address: @homeowner.address, driveway_active: @homeowner.driveway_active, driveway_description: @homeowner.driveway_description, driveway_price: @homeowner.driveway_price, driveway_verified: @homeowner.driveway_verified, last_modified: @homeowner.last_modified, latitude: @homeowner.latitude, longitude: @homeowner.longitude, number_ratings: @homeowner.number_ratings, total_ratings: @homeowner.total_ratings, user_id: @homeowner.user_id } }
    assert_redirected_to homeowner_url(@homeowner)
  end

  test "should destroy homeowner" do
    assert_difference('Homeowner.count', -1) do
      delete homeowner_url(@homeowner)
    end

    assert_redirected_to homeowners_url
  end
end
