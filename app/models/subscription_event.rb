class SubscriptionEvent < ActiveRecord::Base
  self.inheritance_column = nil
  belongs_to :account

  def self.process_webhook(type, data)
    account = Account.find_by!(stripe_customer_id: data["object"]["customer"])
    account.subscription_events.create(
      type: type,
      data: data,
    )

    if type == "customer.subscription.updated"
      handle_subscription_updated_event(account, data)
    end
  end

  def self.handle_subscription_updated_event(account, data)
    account.stripe_subscription_status = data["object"]["status"]
    account.save
  end
end
