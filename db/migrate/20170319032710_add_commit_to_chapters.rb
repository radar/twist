class AddCommitToChapters < ActiveRecord::Migration[5.0]
  def change
    add_column :chapters, :commit, :string
    add_index :chapters, [:book_id, :commit]
  end
end
