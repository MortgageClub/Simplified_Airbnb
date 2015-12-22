require 'rails_helper'
require 'spec_helper'

describe UsersController do
    describe "GET /show" do
      let(:user) { FactoryGirl.create(:user) }
      let(:rooms) { FactoryGirl.create_list(:room, 3, user: user) }

      it "assigns the requested user to @user" do
        get :show, id: user
        expect(assigns(:user)).to eq(user)
      end

      it "assigns the requested rooms to @rooms" do
        get :show, id: user
        expect(assigns(:rooms)).to eq(rooms)
      end

      it "renders the :show template" do
        get :show, id: user
        expect(response).to render_template :show
      end
    end
end
