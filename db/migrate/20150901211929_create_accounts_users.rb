class CreateAccountsUsers < ActiveRecord::Migration
  def change
    create_table :accounts_users, id: false do |t|
      t.integer :account_id
      t.integer :user_id
    end
  end
end
