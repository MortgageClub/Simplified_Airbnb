require 'rails_helper'

describe User do
  it "is valid with a fullname, email and password" do
    user = User.new(
      fullname: "Tang Nguyen Van",
      email: "tinhte@gmail.com",
      password: "12345678")
    expect(user).to be_valid
  end

  it { should validate_presence_of(:fullname) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_length_of(:password).is_at_least(8) }

  it "is invalid with a duplicate email address" do
    User.create(
      fullname: "test",
      email: "nvtang92@gmail.com",
      password: "12345678")
    user = User.new(
      fullname: "test",
      email: "nvtang92@gmail.com",
      password: "12345678")
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end
end
