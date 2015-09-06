class RemoveForeignKeyFromBooks < ActiveRecord::Migration
  def change
    remove_foreign_key :books, :account
  end
end
