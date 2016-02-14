class AddAccountIdToBooks < ActiveRecord::Migration
  def change
    add_reference :books, :account, index: true, foreign_key: true
  end
end
