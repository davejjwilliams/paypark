require 'test_helper'

class ConversationsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user2 = users(:two)
  end

  #test "Should create conversation" do
  #
  #  assert_difference('Conversation.count') do
  #    post conversations_url, params: { conversation: {
  #      user_id: @user2
  #    } }
  #  end

  #end
end
