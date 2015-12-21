class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation

  def index
    if current_user == @conversation.sender || current_user == @conversation.recipient
      @other = sender? ? @conversation.recipient : @conversation.sender
      @messages = @conversation.messages.order("created_at DESC")
    else
      redirect_to conversations_path, alert: "You don't have permission to view this."
    end
  end

  def create
    @message = @conversation.messages.new(message_params)
    @messages = @conversation.messages.order("created_at DESC")

    redirect_to conversation_messages_path(@conversation) if @message.save
  end

  private

  def sender?
    current_user == @conversation.sender
  end

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:content, :user_id)
  end
end
