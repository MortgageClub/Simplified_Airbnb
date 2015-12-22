require 'rails_helper'
require 'spec_helper'

describe PhotosController do
  describe "DELETE #destroy" do
    let(:room) { FactoryGirl.create(:room) }
    let!(:photo) { FactoryGirl.create(:photo, image: "https://robohash.org/sitsequiquia.png", room: room) }

    it "deletes the photo" do
      expect{
        delete :destroy, id: photo, format: "js"
      }.to change(Photo, :count).by(-1)
    end

    it "assigns the requested photos to @photos" do
      delete :destroy, id: photo, format: "js"
      expect(assigns(:photos).size).to eq 0
    end

    it "renders the :destroy js template" do
      delete :destroy, id: photo, format: "js"
      expect(response).to render_template("destroy", format: "js")
    end
  end
end
