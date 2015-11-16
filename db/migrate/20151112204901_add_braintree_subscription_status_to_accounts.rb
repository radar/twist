class AddBraintreeSubscriptionStatusToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :braintree_subscription_status, :string
  end
end
