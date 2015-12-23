# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :review do
    comment { Faker::Lorem.sentence }
    star 1
    room
    user
  end
end
