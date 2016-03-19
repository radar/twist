FactoryGirl.define do
  factory :account do
    sequence(:name) { |n| "Test Account ##{n}" }
    sequence(:subdomain) { |n| "test#{n}" }
    association :owner, :factory => :user 

    trait :subscribed do
      stripe_subscription_id "ABC123"
    end
  end
end
