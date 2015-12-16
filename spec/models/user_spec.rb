require 'rails_helper'

describe User do
  it "is valid with a fullname, email and password" do
    user = User.new(
      fullname: "Tang Nguyen Van",
      email: "tinhte@gmail.com",
      password: "12345678")
    expect(user).to be_valid
  end

  it "is invalid without a fullname" do
    user = User.new(fullname: nil)
    user.valid?
    expect(user.errors[:fullname]).to include("can't be blank")
  end

  it "is invalid without a email address" do
    user = User.new(email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "is invalid without a password" do
    user = User.new(password: nil)
    user.valid?
    expect(user.errors[:password]).to include("can't be blank")
  end

  it "is invalid with a password length less than 8" do
    user = User.new(
      fullname: "test",
      email: "test1@gmail.com",
      password: "123457")
    user.valid?
    expect(user.errors[:password]).to include("is too short (minimum is 8 characters)")
  end

  it "is invalid with a duplicate email address" do
    User.create(
      fullname: "test",
      email: "test@gmail.com",
      password: "12345678")
    user = User.new(
      fullname: "test",
      email: "test@gmail.com",
      password: "1234578")
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end
end