class AddPartToChapters < ActiveRecord::Migration[4.2]
  def change
    add_column :chapters, :part, :string

    add_index :chapters, [:book_id, :part]
  end
end
