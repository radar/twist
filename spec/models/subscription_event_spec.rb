require 'rails_helper'

RSpec.describe SubscriptionEvent, type: :model do
  let!(:account) { FactoryGirl.create(:account, braintree_subscription_id: "ABC001") }

  it "can parse a successful charge event" do
    kind = Braintree::WebhookNotification::Kind::SubscriptionChargedSuccessfully
    sample_notification = Braintree::WebhookTesting.sample_notification(
      kind, "ABC001"
    )

    SubscriptionEvent.process_webhook(sample_notification)

    expect(account.subscription_events.count).to eq(1)

    event = account.subscription_events.first
    expect(event.kind).to eq(kind)
  end

  it "can parse a unsuccessful charge event" do
    kind = Braintree::WebhookNotification::Kind::SubscriptionChargedUnsuccessfully
    sample_notification = Braintree::WebhookTesting.sample_notification(
      kind, "ABC001"
    )

    SubscriptionEvent.process_webhook(sample_notification)

    expect(account.subscription_events.count).to eq(1)

    event = account.subscription_events.first
    expect(event.kind).to eq(kind)
  end


  it "can parse a past-due event" do
    kind = Braintree::WebhookNotification::Kind::SubscriptionWentPastDue
    sample_notification = Braintree::WebhookTesting.sample_notification(
      kind, "ABC001"
    )

    SubscriptionEvent.process_webhook(sample_notification)

    expect(account.subscription_events.count).to eq(1)

    event = account.subscription_events.first
    expect(event.kind).to eq(kind)
  end

  it "can parse a cancelled event" do
    kind = Braintree::WebhookNotification::Kind::SubscriptionCanceled
    sample_notification = Braintree::WebhookTesting.sample_notification(
      kind, "ABC001"
    )

    SubscriptionEvent.process_webhook(sample_notification)

    expect(account.subscription_events.count).to eq(1)

    event = account.subscription_events.first
    expect(event.kind).to eq(kind)
  end
end
