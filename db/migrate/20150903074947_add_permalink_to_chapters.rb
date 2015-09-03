class AddPermalinkToChapters < ActiveRecord::Migration
  def change
    add_column :chapters, :permalink, :string
    add_index :chapters, [:book_id, :permalink]
  end
end
