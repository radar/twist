class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.integer :book_id, index: true
      t.integer :position
      t.string :title
      t.string :file_name

      t.timestamps null: false
    end
  end
end
