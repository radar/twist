class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :note_id
      t.text :text
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :comments, :note_id
  end
end
