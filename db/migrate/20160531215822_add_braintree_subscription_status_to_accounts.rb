class AddBraintreeSubscriptionStatusToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :braintree_subscription_status, :string
  end
end
