class AddBraintreeCustomerIdToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :braintree_customer_id, :string
  end
end
