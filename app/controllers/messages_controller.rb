class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation
  before_action :authenticate_conversation!, only: :index

  def index
    @other = sender? ? @conversation.recipient : @conversation.sender
    @messages = @conversation.messages.order("created_at DESC")
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

  def authenticate_conversation!
    return redirect_to conversations_path, alert: "You don't have permission to view this." unless conversation_belongs_to_user?
  end

  def conversation_belongs_to_user?
    current_user == @conversation.sender || current_user == @conversation.recipient
  end

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:content, :user_id)
  end
end
