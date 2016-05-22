class AddAuthorToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :author, :boolean, default: false
  end
end
