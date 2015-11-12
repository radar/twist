class AddBraintreeSubscriptionIdToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :braintree_subscription_id, :string
  end
end
