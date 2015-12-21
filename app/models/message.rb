class Message < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :user

  validate_presence_of :content, :conversation_id, :user_id

  def manage_time
    created_at.strftime("%v")
  end
end
