require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get contact" do
    get contact_url
    assert_response :success
  end

end
