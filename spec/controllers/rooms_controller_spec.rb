require 'rails_helper'
require 'spec_helper'

describe RoomsController do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:room) { FactoryGirl.create(:room, user: user, price: 100) }

  before do
    sign_in user
    FactoryGirl.create_list(:room, 3, user: user)
  end

  it { should use_before_action(:authenticate_user!) }
  it { should use_before_action(:set_room) }

  describe "GET #index" do
    it "assigns the requested rooms to @rooms" do
      get :index
      expect(assigns(:rooms)).to eq(user.rooms)
    end

    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    it "assigns the requested room to @room" do
      get :show, id: room
      expect(assigns(:room)).to eq(room)
    end

    it "assigns the requested photos to @photos" do
      get :show, id: room
      expect(assigns(:photos)).to eq(room.photos)
    end

    it "renders the :show template" do
      get :show, id: room
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    it "assigns the new room to @room" do
      get :new
      expect(assigns(:room)).to be_a(Room)
    end

    it "renders the :new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "GET #edit" do
    let(:room_temp) { FactoryGirl.create(:room) }

    it "assigns the requested room to @room" do
      get :edit, id: room
      expect(assigns(:room)).to eq(room)
    end

    it "assigns the requested photos to @photos" do
      get :edit, id: room
      expect(assigns(:photos)).to eq(room.photos)
    end

    it "redirects to the root path" do
      get :edit, id: room_temp
      expect(response).to redirect_to root_url
    end

    it "renders the :edit template" do
      get :edit, id: room
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new room in the database" do
        expect { post :create, room: attributes_for(:room) }.to change(Room, :count).by(1)
      end

      it "calls the #insert_images_to_room" do
        expect_any_instance_of(RoomsController).to receive(:insert_images_to_room)
        post :create, room: attributes_for(:room), images: []
      end

      it "assigns the @room.photos to @photos" do
        post :create, room: attributes_for(:room)
        expect(assigns(:photos)).to eq(Room.last.photos)
      end

      it "redirects to rooms#edit" do
        post :create, room: attributes_for(:room)
        expect(response).to redirect_to edit_room_path(assigns(:room))
      end
    end

    context "with invalid attributes" do
      it "does not save the new room in the database" do
        expect { post :create, room: attributes_for(:invalid_room) }.to_not change(Room, :count)
      end

      it "re-renders the :new template" do
        post :create, room: attributes_for(:invalid_room)
        expect(response).to render_template :new
      end
    end
  end
  describe "PATCH #update" do
    context "with valid attributes" do
      it "locates the requested room" do
        patch :update, id: room, room: attributes_for(:room)
        expect(assigns(:room)).to eq(room)
      end

      it "changes room's attributes" do
        patch :update, id: room, room: attributes_for(:room, price: 1000)
        room.reload
        expect(room.price).to eq(1000)
      end

      it "redirects to the room#edit" do
        patch :update, id: room, room: attributes_for(:room)
        expect(response).to redirect_to edit_room_path(room)
      end
    end

    context "with invalid attributes" do
      it "does not change room's attributes" do
        patch :update, id: room, room: attributes_for(:room, price: nil)
        room.reload
        expect(room.price).to eq(100)
      end

      it "re-renders the :edit template" do
        patch :update, id: room, room: attributes_for(:room, price: nil)
        expect(response).to render_template :edit
      end
    end
  end
end
