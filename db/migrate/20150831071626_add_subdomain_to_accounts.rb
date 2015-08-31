class AddSubdomainToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :subdomain, :string
    add_index :accounts, :subdomain
  end
end
