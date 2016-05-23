class AddSubdomainToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :subdomain, :string
    add_index :accounts, :subdomain
  end
end
