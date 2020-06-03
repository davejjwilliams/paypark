require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "Should create valid user" do
    user = User.new

    user.name = "Name"
    user.email = "test@mail.com"
    user.password = "Password"

    user.save

    assert user.valid?
  end

  test "Should not create invalid user" do
    # Missing name
    user = User.new

    user.email = "test@mail.com"
    user.password = "Password"

    user.save

    assert user.invalid?

    # Missing email
    user1 = User.new

    user1.name = "Name"
    user.password = "Password"

    user1.save

    assert user1.invalid?

    # Missing password
    user2 = User.new

    user2.name = "Name"
    user2.email = "test@mail.com"

    user2.save

    assert user2.invalid?

  end

end
