require 'rails_helper'
require 'spec_helper'

describe Room do
  it { should validate_presence_of(:home_type) }
  it { should validate_presence_of(:room_type) }
  it { should validate_presence_of(:accommodate) }
  it { should validate_presence_of(:bed_room) }
  it { should validate_presence_of(:bath_room) }
  it { should validate_presence_of(:listing_name) }
  it { should validate_length_of(:listing_name).is_at_most(50) }
  it { should validate_presence_of(:summary) }
  it { should validate_length_of(:summary).is_at_most(500) }
  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:price) }

  it { should belong_to(:user) }
  it { should have_many(:photos) }
  it { should have_many(:reservations) }
  it { should have_many(:reviews) }

  describe "#show_image_first" do
    let(:room) { FactoryGirl.build(:room) }

    it "returns first image url" do
      FactoryGirl.create(:photo, room: room, image: "https://robohash.org/sitsequiquia.png?size=300x300")
      expect(room.show_image_first(:medium)).to include("sitsequiquia.png")
    end

    it "returns default image when photos nil" do
      expect(room.show_image_first(:medium)).to eq("/system/photos/default.jpg")
    end
  end

  describe "#average_rating" do
    let(:room) { FactoryGirl.create(:room) }

    it "returns the 0 with no review" do
      expect(room.average_rating).to eq(0)
    end

    it "returns the avarage rating with reviews" do
      FactoryGirl.create(:review, room: room, star: 4)
      FactoryGirl.create(:review, room: room, star: 5)
      expect(room.average_rating).to eq(4.5)
    end
  end
end
