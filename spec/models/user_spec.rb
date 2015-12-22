require 'rails_helper'
require 'spec_helper'

describe User do
  user = FactoryGirl.build(:user)

  it { expect(user).to be_valid }
  it { should validate_presence_of(:fullname) }
  it { should validate_length_of(:fullname).is_at_most(50) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_length_of(:password).is_at_least(8) }
  it { should have_many(:rooms) }
  it { should have_many(:reservations) }
  it { should have_many(:messages) }

  context "when duplicated email" do
    it "raises a duplicate error" do
      FactoryGirl.create(:user, email: "tang@mortgageclub.co")
      temp_user = FactoryGirl.build(:user, email: "tang@mortgageclub.co")
      temp_user.valid?
      expect(temp_user.errors[:email]).to include("has already been taken")
    end
  end
end
