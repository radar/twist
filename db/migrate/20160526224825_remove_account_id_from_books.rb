class RemoveAccountIdFromBooks < ActiveRecord::Migration[5.0]
  def change
    remove_column :books, :account_id
  end
end
