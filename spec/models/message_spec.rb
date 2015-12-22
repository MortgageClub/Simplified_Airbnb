require 'rails_helper'
require 'spec_helper'

describe Message do
  it { should belong_to(:conversation) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:conversation_id) }
  it { should validate_presence_of(:user_id) }

  describe "#message_time" do
    let!(:sender) { FactoryGirl.create(:user, email: "tang@tang-airbnb.com") }
    let!(:recipient) { FactoryGirl.create(:user, email: "cuong@tang-airbnb.com") }
    let!(:conversation) { FactoryGirl.create(:conversation, sender: sender, recipient: recipient) }
    let!(:message) { FactoryGirl.create(:message, user: sender, conversation: conversation) }

    it "returns a correct format time" do
      time_now = Time.zone.now.strftime("%v")
      expect(message.message_time).to eq(time_now)
    end
  end
end
