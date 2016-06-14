class SubscriptionEvent < ApplicationRecord
  belongs_to :account

  def self.process_webhook(webhook)
    event = Braintree::WebhookNotification.parse(
      webhook[:bt_signature],
      webhook[:bt_payload]
    )

    return if event.kind == Braintree::WebhookNotification::Kind::Check

    account = Account.find_by!(braintree_subscription_id: event.subscription.id)
    account.subscription_events.create!(
      kind: event.kind
    )

    if event.kind == Braintree::WebhookNotification::Kind::SubscriptionWentPastDue
      account.update(braintree_subscription_status: "Past Due")
    end
  end
end
