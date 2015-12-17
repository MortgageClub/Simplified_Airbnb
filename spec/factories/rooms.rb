# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :room do
    home_type "MyString"
    room_type "MyString"
    accommodate 1
    bed_room 1
    bath_room "MyString"
    integer "MyString"
    listing_name "MyString"
    summary "MyText"
    address "MyString"
    is_tv false
    is_kitchen false
    is_air false
    is_heating false
    is_internet false
    price 1
    active false
    user nil
  end
end
