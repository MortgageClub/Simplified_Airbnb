# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :room do
    home_type "Apartment"
    room_type "Entire"
    accommodate 1
    bed_room 1
    bath_room 1
    listing_name { Faker::Lorem.characters(50) }
    summary { Faker::Lorem.characters(500) }
    address { Faker::Address.street_address }
    is_tv true
    is_kitchen true
    is_air false
    is_heating false
    is_internet false
    price 100
    active false
    user

    factory :invalid_room do
      price nil
    end
  end
end
