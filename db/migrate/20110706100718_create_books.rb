class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.integer :user_id
      t.string :path
      t.string :title

      t.timestamps
    end
  end
end
