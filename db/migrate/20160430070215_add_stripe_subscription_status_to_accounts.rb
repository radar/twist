class AddStripeSubscriptionStatusToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :stripe_subscription_status, :string
  end
end
