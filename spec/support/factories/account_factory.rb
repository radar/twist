FactoryGirl.define do
  factory :account do
    sequence(:name) { |n| "Test Account ##{n}" }
    sequence(:subdomain) { |n| "test#{n}" }
    association :owner, :factory => :user 

    trait :subscribed do
      braintree_subscription_id 'abc123'
      braintree_subscription_status 'Active'
    end
  end
end
