require "application_system_test_case"

class WithdrawalRequestsTest < ApplicationSystemTestCase
  setup do
    @withdrawal_request = withdrawal_requests(:one)
  end

  test "visiting the index" do
    visit withdrawal_requests_url
    assert_selector "h1", text: "Withdrawal Requests"
  end

  test "creating a Withdrawal request" do
    visit withdrawal_requests_url
    click_on "New Withdrawal Request"

    fill_in "Amount", with: @withdrawal_request.amount
    fill_in "Homeowner", with: @withdrawal_request.homeowner_id
    fill_in "Request date", with: @withdrawal_request.request_date
    click_on "Create Withdrawal request"

    assert_text "Withdrawal request was successfully created"
    click_on "Back"
  end

  test "updating a Withdrawal request" do
    visit withdrawal_requests_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @withdrawal_request.amount
    fill_in "Homeowner", with: @withdrawal_request.homeowner_id
    fill_in "Request date", with: @withdrawal_request.request_date
    click_on "Update Withdrawal request"

    assert_text "Withdrawal request was successfully updated"
    click_on "Back"
  end

  test "destroying a Withdrawal request" do
    visit withdrawal_requests_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Withdrawal request was successfully destroyed"
  end
end
