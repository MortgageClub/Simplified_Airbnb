# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reservation do
    user
    room
    start_date "2015-12-18 16:30:36"
    end_date "2015-12-18 16:30:36"
    price 1
    total 1
  end
end
