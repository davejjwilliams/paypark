require 'test_helper'

class ConversationTest < ActiveSupport::TestCase

  setup do
    @user1 = users(:two)
    @user2 = users(:three)
  end

  test "Should save conversation" do

    conversation = Conversation.new

    conversation.sender = @user1
    conversation.recipient = @user2

    conversation.save

    assert conversation.valid?

  end

  test "Should not save conversation that already exists between users" do

    conversation = Conversation.new

    conversation.sender = @user1
    conversation.recipient = @user2

    conversation.save

    assert conversation.valid?

    conversation2 = Conversation.new

    conversation2.sender = @user1
    conversation2.recipient = @user2

    conversation2.save

    assert conversation2.invalid?

  end

end
