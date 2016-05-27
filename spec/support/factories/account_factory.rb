FactoryGirl.define do
  factory :account do
    sequence(:name) { |n| "Test Account ##{n}" }
    sequence(:subdomain) { |n| "test#{n}" }
    association :owner, :factory => :user 

    trait :with_schema do
      after(:create) do |account|
        account.create_schema
      end
    end
  end
end
