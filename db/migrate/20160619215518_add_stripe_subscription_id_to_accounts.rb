class AddStripeSubscriptionIdToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :stripe_subscription_id, :string
  end
end
