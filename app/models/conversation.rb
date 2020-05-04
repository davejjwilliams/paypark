class Conversation < ApplicationRecord

  # Association to messages
  has_many :messages, dependent: :destroy

  # Association to the sender and the recipient, both of whom are users
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'

  # Guarantee that the sender is not the same as the recipient
  validates :sender_id, uniqueness: { scope: :recipient_id }

  # Define scope
  scope :between, -> (sender_id, recipient_id) do
    where(sender_id: sender_id, recipient_id: recipient_id).or(where(sender_id: recipient_id, recipient_id: sender_id))
  end

  # Return the conversation between two users if existant, else create the conversation
  def self.get(sender_id, recipient_id)
    conversation = between(sender_id, recipient_id).first
    return conversation if conversation.present?

    create(sender_id: sender_id, recipient_id: recipient_id)
  end

  # Get the user that a given user is conversing with
  def opposed_user(user)
    user == recipient ? sender : recipient
  end

end
