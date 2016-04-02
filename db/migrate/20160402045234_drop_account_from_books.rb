class DropAccountFromBooks < ActiveRecord::Migration
  def change
    remove_column :books, :account
  end
end
