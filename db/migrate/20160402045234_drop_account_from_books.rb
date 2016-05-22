class DropAccountFromBooks < ActiveRecord::Migration[4.2]
  def change
    remove_column :books, :account
  end
end
