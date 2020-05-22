require 'test_helper'

class WithdrawalRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @homeowner = homeowners(:one)
    @withdrawal_request = withdrawal_requests(:one)
  end

  test "should get index" do
    get withdrawal_requests_url
    assert_response :success
  end

  test "should get new" do
    get new_withdrawal_request_url
    assert_response :success
  end

  test "should create withdrawal_request" do
    assert_difference('WithdrawalRequest.count') do
      post withdrawal_requests_url, params: { withdrawal_request: { amount: @withdrawal_request.amount, homeowner_id: @homeowner.id, request_date: @withdrawal_request.request_date } }
    end

    assert_redirected_to withdrawal_request_url(WithdrawalRequest.last)
  end

  test "should show withdrawal_request" do
    get withdrawal_request_url(@withdrawal_request)
    assert_response :success
  end

  test "should get edit" do
    get edit_withdrawal_request_url(@withdrawal_request)
    assert_response :success
  end

  test "should update withdrawal_request" do
    patch withdrawal_request_url(@withdrawal_request), params: { withdrawal_request: { amount: @withdrawal_request.amount, homeowner_id: @withdrawal_request.homeowner_id, request_date: @withdrawal_request.request_date } }
    assert_redirected_to @withdrawal_request
  end

  test "should destroy withdrawal_request" do
    assert_difference('WithdrawalRequest.count', -1) do
      delete withdrawal_request_url(@withdrawal_request)
    end

    assert_redirected_to withdrawal_requests_url
  end
end
