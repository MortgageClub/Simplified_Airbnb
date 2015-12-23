require 'rails_helper'
require 'spec_helper'

describe MessagesController do
  let(:user) { FactoryGirl.create(:user) }
  let(:sender) { FactoryGirl.create(:user) }
  let(:recipient) { FactoryGirl.create(:user) }
  let(:conversation) { FactoryGirl.create(:conversation, sender_id: user.id, recipient_id: recipient.id) }
  let(:conversation_permission) { FactoryGirl.create(:conversation, sender_id: sender.id, recipient_id: recipient.id) }

  before do
    sign_in user
  end

  it { should use_before_action(:authenticate_user!) }
  it { should use_before_action(:set_conversation) }
  it { should use_before_action(:authenticate_conversation!) }

  describe "GET /index" do
    it "assigns the requested conversation to @conversation" do
      get :index, conversation_id: conversation.id
      expect(assigns(:conversation)).to eq(conversation)
    end

    context "when user has no permission to access conversation" do
      it "redirects to the conversations#index" do
        get :index, conversation_id: conversation_permission.id
        expect(response).to redirect_to conversations_path
      end
    end

    context "when user has permission to access conversation" do
      it "assigns the recipient to @other" do
        get :index, conversation_id: conversation.id
        expect(assigns(:other)).to eq(recipient)
      end

      it "assigns the conversation messages to @messages" do
        get :index, conversation_id: conversation.id
        expect(assigns(:messages)).to eq(conversation.messages.order("created_at DESC"))
      end

      it "renders the :index template" do
        get :index, conversation_id: conversation.id
        expect(response).to render_template :index
      end
    end
  end

  describe "POST /create" do
    it "assigns the requested conversation to @conversation" do
      post :create, conversation_id: conversation.id, message: attributes_for(:message, conversation_id: conversation.id, user_id: user.id), format: :js
      expect(assigns(:conversation)).to eq(conversation)
    end

    it "saves the new message in the database" do
      expect do
        post :create, conversation_id: conversation, message: attributes_for(:message, conversation_id: conversation.id, user_id: user.id), format: :js
      end.to change(Message, :count).by(1)
    end

    it "assigns the conversation messages to @messages" do
      post :create, conversation_id: conversation.id, message: attributes_for(:message, conversation_id: conversation.id, user_id: user.id), format: :js
      expect(assigns(:messages)).to eq(conversation.messages.order("created_at DESC"))
    end

    it "renders the :create js template" do
      post :create, conversation_id: conversation.id, message: attributes_for(:message, conversation_id: conversation.id, user_id: user.id), format: :js
      expect(response).to render_template(:create, format: :js)
    end
  end
end
