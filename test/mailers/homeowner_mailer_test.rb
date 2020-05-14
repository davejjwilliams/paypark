require 'test_helper'

class HomeownerMailerTest < ActionMailer::TestCase
  test "homeowner_confirmation" do
    mail = HomeownerMailer.homeowner_confirmation
    assert_equal "Homeowner confirmation", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
