class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :title
      t.string :identifier
      t.integer :chapter_id
      t.integer :number
      t.integer :parent_id
    end
  end
end
