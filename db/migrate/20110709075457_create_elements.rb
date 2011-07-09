class CreateElements < ActiveRecord::Migration
  def change
    create_table :elements do |t|
      t.integer :chapter_id
      t.string :identifier
      t.text :content
      t.string :tag
      t.integer :current_version, :default => 1
    end
    
    add_index :elements, :chapter_id
    
    create_table :element_versions do |t|
      t.integer :element_id
      t.text :content
      t.string :tag
      t.integer :number
    end
    
    add_index :element_versions, :element_id
  end
end
