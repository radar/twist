class AddAccountIdToBooks < ActiveRecord::Migration[5.0]
  def change
    add_reference :books, :account, foreign_key: true
  end
end
