# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do |f|
    f.fullname { Faker::Name.name }
    f.email { Faker::Internet.email }
    f.password { Faker::Internet.password(8) }
  end
end
