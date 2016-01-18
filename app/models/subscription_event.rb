class SubscriptionEvent < ActiveRecord::Base
  belongs_to :account

  def self.process_webhook(webhook)
    event = Braintree::WebhookNotification.parse(
      webhook[:bt_signature],
      webhook[:bt_payload]
    )

    binding.pry

    account = Account.find_by!(braintree_subscription_id: event.subscription.id)
    account.subscription_events.create!(
      kind: event.kind
    )
  end
end
