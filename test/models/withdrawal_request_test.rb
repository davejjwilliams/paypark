require 'test_helper'

class WithdrawalRequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @homeowner = homeowners(:adminhomeowner)
  end

  test "Should create valid withdrawal request" do
    withdrawal_request = WithdrawalRequest.new

    withdrawal_request.homeowner_id = @homeowner.id
    withdrawal_request.amount = 10
    withdrawal_request.request_date = Time.now

    withdrawal_request.save

    assert withdrawal_request.valid?
  end

  test "Should not create withdrawal request with invalid amount" do
    withdrawal_request = WithdrawalRequest.new

    withdrawal_request.homeowner_id = @homeowner.id
    withdrawal_request.amount = -10
    withdrawal_request.request_date = Time.now

    withdrawal_request.save

    assert withdrawal_request.invalid?
  end

  test "Should not create withdrawal request with missing fields" do
    # Missing amount
    withdrawal_request = WithdrawalRequest.new

    withdrawal_request.homeowner_id = @homeowner.id
    withdrawal_request.request_date = Time.now

    withdrawal_request.save

    assert withdrawal_request.invalid?

    # Missing request date
    withdrawal_request1 = WithdrawalRequest.new

    withdrawal_request1.homeowner_id = @homeowner.id
    withdrawal_request1.amount = 10

    withdrawal_request1.save

    assert withdrawal_request1.invalid?
  end


end
