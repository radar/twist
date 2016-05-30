class AddBraintreeSubscriptionIdToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :braintree_subscription_id, :string
  end
end
