class RemoveAccountIdFromBooks < ActiveRecord::Migration
  def change
    remove_column :books, :account_id
  end
end
