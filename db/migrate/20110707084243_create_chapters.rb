class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.integer :book_id
      t.integer :position
      t.string :title
      t.string :type
    end
  end
end
