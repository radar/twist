class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :text
      t.integer :element_id
      t.integer :number
      t.string :state, default: "new"
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :notes, :element_id
  end
end
