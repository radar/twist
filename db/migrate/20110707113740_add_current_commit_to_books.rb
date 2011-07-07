class AddCurrentCommitToBooks < ActiveRecord::Migration
  def change
    add_column :books, :current_commit, :string
  end
end
