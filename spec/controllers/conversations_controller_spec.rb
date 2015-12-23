require 'rails_helper'
require 'spec_helper'

describe ConversationsController do
  let(:user) { FactoryGirl.create(:user) }

  before do
    sign_in user
  end

  it { should use_before_action(:authenticate_user!) }

  describe "GET /index" do
    FactoryGirl.create_list(:user, 3)

    it "assigns the requested users to @users" do
      get :index
      expect(assigns(:users)).to eq(User.all)
    end

    it "assigns the conversations of current user to @conversations" do
      get :index
      expect(assigns(:conversations)).to eq(Conversation.involving(user))
    end

    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "POST /create" do
    let!(:recipient) { FactoryGirl.create(:user) }

    context "with no conversation between user and recipient" do
      it "saves the new conversation in the database" do
        expect { post :create, sender_id: user.id, recipient_id: recipient.id }.to change(Conversation, :count).by(1)
      end
    end

    context "with a conversation between user and recipient" do
      let!(:sender) { FactoryGirl.create(:user) }
      let!(:conversation) { FactoryGirl.create(:conversation, sender_id: sender.id, recipient_id: recipient.id) }

      it "assigns the requested conversation to @conversation" do
        post :create, sender_id: sender.id, recipient_id: recipient.id
        expect(assigns(:conversation)).to eq(conversation)
      end
    end

    it "redirects to messages#index" do
      post :create, sender_id: user.id, recipient_id: recipient.id
      expect(response).to redirect_to conversation_messages_path(assigns(:conversation))
    end
  end
end
