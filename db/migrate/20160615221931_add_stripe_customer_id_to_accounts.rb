class AddStripeCustomerIdToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :stripe_customer_id, :string
  end
end
