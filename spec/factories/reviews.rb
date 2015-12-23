# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :review do
    comment "MyText"
    star 1
    room nil
    user nil
  end
end
