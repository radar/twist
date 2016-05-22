class AddOldToElements < ActiveRecord::Migration[4.2]
  def change
    add_column :elements, :old, :boolean, default: false
    add_column :elements, :notes_count, :integer, default: 0
  end
end
