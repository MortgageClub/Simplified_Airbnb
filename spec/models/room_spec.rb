require 'rails_helper'

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
end
