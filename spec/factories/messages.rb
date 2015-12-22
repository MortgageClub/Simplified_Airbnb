# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    content { Faker::Lorem.sentence }
    conversation
    user
  end
end
