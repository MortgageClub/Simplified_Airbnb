require 'rails_helper'
require 'spec_helper'

describe ReservationsController do
  let(:user) { FactoryGirl.create(:user) }
  let!(:room) { FactoryGirl.create(:room) }
  let!(:reservation) { FactoryGirl.create(:reservation, start_date: Time.zone.tomorrow, end_date: Time.zone.now + 10.days, room_id: room.id) }

  before do
    sign_in user
  end

  it { should use_before_action(:authenticate_user!) }

  describe "GET /your_trips" do
    it "assigns the reservations of current user to @reservations" do
      get :your_trips
      expect(assigns(:trips)).to eq(user.reservations)
    end

    it "renders the :your_trips template" do
      get :your_trips
      expect(response).to render_template :your_trips
    end
  end

  describe "GET /your_reservations" do
    it "assigns the rooms of current user to @rooms" do
      get :your_reservations
      expect(assigns(:rooms)).to eq(user.rooms)
    end

    it "renders the :your_reservations template" do
      get :your_reservations
      expect(response).to render_template :your_reservations
    end
  end

  describe "POST /create" do
    let(:room) { FactoryGirl.create(:room, user: user) }

    it "saves the new reservation in the database" do
      expect { post :create, room_id: room, reservation: attributes_for(:reservation, room_id: room.id, price: 100) }.to change(Reservation, :count).by(1)
    end

    it "assigns the new reservation to @reservation" do
      post :create, room_id: room, reservation: attributes_for(:reservation, room_id: room.id, price: 100)
      expect(assigns(:reservation).price).to eq(100)
    end

    it "redirects to the room#show" do
      post :create, room_id: room, reservation: attributes_for(:reservation, room_id: room.id, price: 100)
      expect(response).to redirect_to assigns(:reservation).room
    end
  end

  describe "GET /preload" do
    it "gets all reservations unavailable next days" do
      get :preload, room_id: room.id
      expect(response.body).to eq([reservation].to_json)
    end
  end

  describe "GET /preview" do
    it "show conflict if a new reservation has a reservation between start_date and end_date" do
      get :preview, room_id: room.id, start_date: Time.zone.now, end_date: Time.zone.now + 16.days
      expect(JSON.parse(response.body)["conflict"]).to eq true
    end
  end
end
