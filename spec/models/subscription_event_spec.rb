require 'rails_helper'

RSpec.describe SubscriptionEvent, type: :model do
  let!(:account) do
    FactoryGirl.create(:account,
      stripe_subscription_id: "sub_001",
      stripe_customer_id: "cus_001"
    )
  end

  it "stores a customer.subscription.created event" do
    SubscriptionEvent.process_webhook(
      "customer.subscription.created",
      {
        "object" => { "id" => "sub_001", "customer" => "cus_001" },
      }
    )

    expect(account.subscription_events.count).to eq(1)

    event = account.subscription_events.first
    expect(event.type).to eq("customer.subscription.created")
  end
  
  it "stores a charge.succeeded event" do
    SubscriptionEvent.process_webhook(
      "charge.succeeded",
      {
        "object" => { "id" => "ch_001", "customer" => "cus_001" },
      }
    )

    expect(account.subscription_events.count).to eq(1)

    event = account.subscription_events.first
    expect(event.type).to eq("charge.succeeded")
  end

  it "stores a charge.failed event" do
    SubscriptionEvent.process_webhook(
      "charge.failed",
      {
        "object" => { "id" => "ch_001", "customer" => "cus_001" },
      }
    )

    expect(account.subscription_events.count).to eq(1)

    event = account.subscription_events.first
    expect(event.type).to eq("charge.failed")
  end

  it "stores a customer.subscription.deleted event" do
    SubscriptionEvent.process_webhook(
      "customer.subscription.deleted",
      {
        "object" => { "id" => "sub_001", "customer" => "cus_001" },
      }
    )

    expect(account.subscription_events.count).to eq(1)

    event = account.subscription_events.first
    expect(event.type).to eq("customer.subscription.deleted")
  end

  it "handles a customer.subscription.updated event with an unpaid status" do
    SubscriptionEvent.process_webhook(
      "customer.subscription.updated",
      {
        "object" => { 
          "id" => "sub_001",
          "customer" => "cus_001", 
          "status" => "unpaid"
        },
      }
    )

    expect(account.subscription_events.count).to eq(1)

    event = account.subscription_events.first
    expect(event.type).to eq("customer.subscription.updated")
    account.reload
    expect(account.stripe_subscription_status).to eq("unpaid")
  end

  it "handles a customer.subscription.updated event with an active status" do
    account.stripe_subscription_status = "unpaid"
    account.save

    SubscriptionEvent.process_webhook(
      "customer.subscription.updated",
      {
        "object" => { 
          "id" => "sub_001",
          "customer" => "cus_001", 
          "status" => "active"
        },
      }
    )

    expect(account.subscription_events.count).to eq(1)

    event = account.subscription_events.first
    expect(event.type).to eq("customer.subscription.updated")
    account.reload
    expect(account.stripe_subscription_status).to eq("active")
  end
end
