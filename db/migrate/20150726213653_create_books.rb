class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.integer :account, index: true
      t.string :path
      t.string :title
      t.string :blurb
      t.string :permalink
      t.string :current_commit
      t.boolean :just_added
      t.boolean :processing
      t.integer :notes_count, default: 0
      t.boolean :hidden, default: false

      t.timestamps null: false
    end
  end
end
