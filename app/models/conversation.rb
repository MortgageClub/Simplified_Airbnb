class Conversation < ActiveRecord::Base
  belongs_to :sender, foreign_key: :sender_id, class_name: "User"
  belongs_to :recipient, foreign_key: :recipient_id, class_name: "User"

  has_many :messages, dependent: :destroy
  validates :sender_id, uniqueness: {scope: :recipient_id}

  scope :involving, lambda { |user|
    where("conversations.sender_id = ? OR conversations.recipient_id = ?", user.id, user.id)
  }

  scope :between, lambda { |sender_id, recipient_id|
    where("(conversations.sender_id = ? AND conversations.recipient_id = ?)
    OR (conversations.sender_id = ? AND conversations.recipient_id = ?)",
    sender_id, recipient_id, recipient_id, sender_id)
  }
end
