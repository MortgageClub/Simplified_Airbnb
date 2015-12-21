class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
    @conversations = Conversation.involving(current_user)
  end

  def create
    conversations = Conversation.between(params[:sender_id], params[:recipient_id])

    @conversation = conversations.present? ? conversations.first : Conversation.create(conversation_params)
    redirect_to conversation_messages_path(@conversation)
  end

  private

  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end
end
