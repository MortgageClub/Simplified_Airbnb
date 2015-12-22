require 'rails_helper'

describe Conversation do
  it { should belong_to(:sender) }
  it { should belong_to(:recipient) }
  it { should have_many(:messages) }

  describe ".involving(user)" do
    context "When there are conversations" do
      let!(:user) { FactoryGirl.create(:user) }
      let!(:sender) { FactoryGirl.create(:user, email: "linh@tang-airbnb.com") }
      let!(:recipient) { FactoryGirl.create(:user, email: "cuong@tang-airbnb.com") }
      let!(:conversation1) { FactoryGirl.create(:conversation, sender_id: user.id, recipient_id: recipient.id) }
      let!(:conversation2) { FactoryGirl.create(:conversation, sender_id: sender.id, recipient_id: user.id) }

      it "show conversations of user" do
        expect(Conversation.involving(user)).to eq [conversation1, conversation2]
      end
    end

    context "When no conversation" do
      let!(:current_user) { FactoryGirl.create(:user, email: "tang@tang-airbnb.com") }
      let!(:sender) { FactoryGirl.create(:user, email: "linh@tang-airbnb.com") }
      let!(:recipient) { FactoryGirl.create(:user, email: "cuong@tang-airbnb.com") }
      let!(:conversation) { FactoryGirl.create(:conversation, sender_id: sender.id, recipient_id: recipient.id) }

      it "show no conversation" do
        expect(Conversation.involving(current_user)).to be_empty
      end
    end
  end

  describe ".between(sender_id, recipient_id)" do
    let!(:user) { FactoryGirl.create(:user, email: "tang@tang-airbnb.com") }
    let!(:sender) { FactoryGirl.create(:user, email: "linh@tang-airbnb.com") }
    let!(:recipient) { FactoryGirl.create(:user, email: "cuong@tang-airbnb.com") }
    let!(:conversation) { FactoryGirl.create(:conversation, sender_id: sender.id, recipient_id: recipient.id) }

    it "show a conversation" do
      expect(Conversation.between(sender.id, recipient.id)).to eq [conversation]
      expect(Conversation.between(recipient.id, sender.id)).to eq [conversation]
    end

    it "show no conversation" do
      expect(Conversation.between(user.id, recipient.id).size).to eq 0
      expect(Conversation.between(recipient.id, user.id).size).to eq 0
    end
  end
end
