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

  describe "GET #your_trips" do
    it "assigns the reservations of current user to @reservations" do
      get :your_trips
      expect(assigns(:trips)).to eq(user.reservations)
    end

    it "renders the :your_trips template" do
      get :your_trips
      expect(response).to render_template :your_trips
    end
  end

  describe "GET #your_reservations" do
    it "assigns the rooms of current user to @rooms" do
      get :your_reservations
      expect(assigns(:rooms)).to eq(user.rooms)
    end

    it "renders the :your_reservations template" do
      get :your_reservations
      expect(response).to render_template :your_reservations
    end
  end

  describe "POST #create" do
    let(:room) { FactoryGirl.create(:room, user: user) }

    it "saves the new reservation in the database" do
      expect do
        post :create, room_id: room, reservation: attributes_for(:reservation, room_id: room.id, price: 100)
      end.to change(Reservation, :count).by(1)
    end

    it "assigns the new reservation to @reservation" do
      post :create, room_id: room, reservation: attributes_for(:reservation, room_id: room.id, price: 100)
      expect(assigns(:reservation).price).to eq(100)
    end

    it "redirects to the paypal" do
      post :create, room_id: room, reservation: attributes_for(:reservation, room_id: room.id, price: 100)
      values = {
        business: 'nhokjoy-facilitator@gmail.com',
        cmd: '_xclick',
        upload: 1,
        notify_url: ENV["NOTIFY_URL"],
        amount: assigns(:reservation).total,
        item_name: assigns(:reservation).room.listing_name,
        item_number: assigns(:reservation).id,
        quantity: '1',
        return: ENV["RETURN_URL"]
      }
      expect(response).to redirect_to "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
    end
  end

  describe "POST #notify" do
    let!(:reservation_notify) { FactoryGirl.create(:reservation, room: room) }
    context "with status completed" do
      it "updates the reservation status" do
        post :notify, payment_status: "Completed", item_number: reservation_notify.id
        reservation_notify.reload
        expect(reservation_notify.status).to eq(true)
      end
    end

    context "with status not completed" do
      it "destroys the reservation" do
        expect { post :notify, payment_status: "Not Completed", item_number: reservation_notify.id }.to change(Reservation, :count).by(-1)
      end
    end
  end

  describe "GET #preload" do
    it "gets all reservations unavailable next days" do
      get :preload, room_id: room.id
      expect(response.body).to eq([reservation].to_json)
    end
  end

  describe "GET #preview" do
    it "show conflict if a new reservation has a reservation between start_date and end_date" do
      get :preview, room_id: room.id, start_date: Time.zone.now, end_date: Time.zone.now + 16.days
      expect(JSON.parse(response.body)["conflict"]).to eq true
    end
  end
end
