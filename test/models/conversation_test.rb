require 'test_helper'

class ConversationTest < ActiveSupport::TestCase

  setup do
    @user1 = users(:three)
    @user2 = users(:four)
  end

  test "Should save conversation" do

    conversation = Conversation.new

    conversation.sender_id = @user1
    conversation.recipient_id = @user2
    conversation.sender = @user1
    conversation.recipient = @user2

    conversation.save

    assert conversation.valid?

  end

  test "Should not save conversation that already exists between users" do

    conversation = Conversation.new

    conversation.sender_id = @user1
    conversation.recipient_id = @user2
    conversation.sender = @user1
    conversation.recipient = @user2

    conversation.save

    assert conversation.valid?

    conversation2 = Conversation.new

    conversation2.sender_id = @user1
    conversation2.recipient_id = @user2
    conversation2.sender = @user1
    conversation2.recipient = @user2

    conversation2.save

    refute conversation2.valid?

  end

end
