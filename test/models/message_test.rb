require 'test_helper'

class MessageTest < ActiveSupport::TestCase

  setup do
    @user1 = users(:one)
    @user2 = users(:two)
  end

  test "Should save message" do

    conversation = Conversation.new

    conversation.sender_id = @user1
    conversation.recipient_id = @user2
    conversation.sender = @user1
    conversation.recipient = @user2

    conversation.save

    assert conversation.valid?


    message = Message.new

    message.user_id = @user1
    message.conversation_id = conversation
    message.body = "Test"
    message.user = @user1
    message.conversation = conversation

    message.save

    assert message.valid?

  end

end
