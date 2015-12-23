require 'rails_helper'
require 'spec_helper'

describe ReviewsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:room) { FactoryGirl.create(:room) }

  before do
    sign_in user
  end

  it { should use_before_action(:authenticate_user!) }

  describe "POST #create" do
    it "saves the new review in the database" do
      expect { post :create, room_id: room.id, review: attributes_for(:review, room_id: room.id) }.to change(Review, :count).by(1)
    end

    it "redirects to room#show" do
      post :create, room_id: room.id, review: attributes_for(:review, room_id: room.id)
      expect(response).to redirect_to assigns(:review).room
    end
  end

  describe "DELETE #destroy" do
    let!(:review) { FactoryGirl.create(:review, user: user, room: room) }

    it "deletes the review from database" do
      expect { delete :destroy, room_id: room.id, id: review }.to change(Review, :count).by(-1)
    end

    it "redirects to room#show" do
      delete :destroy, room_id: room.id, id: review
      expect(response).to redirect_to room
    end
  end
end