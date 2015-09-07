class AddOldToElements < ActiveRecord::Migration
  def change
    add_column :elements, :old, :boolean, default: false
    add_column :elements, :notes_count, :integer, default: 0
  end
end
