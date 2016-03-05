class AddStripeSubscriptionIdToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :stripe_subscription_id, :string
  end
end
