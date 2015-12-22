# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :conversation do
    sender { create(:user) }
    recipient { create(:user) }
  end
end
