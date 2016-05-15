class AddCardDetailsToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :card_last_4, :string
    add_column :accounts, :card_brand, :string
    add_column :accounts, :card_expiry_month, :integer
    add_column :accounts, :card_expiry_year, :integer
  end
end
