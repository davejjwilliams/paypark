require 'test_helper'

class MapControllerTest < ActionDispatch::IntegrationTest
  test "should get map" do
    sign_in users(:admin)
    get root_path
    assert_response :success
  end

end
