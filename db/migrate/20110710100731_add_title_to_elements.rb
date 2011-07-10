class AddTitleToElements < ActiveRecord::Migration
  def change
    add_column :elements, :title, :string
  end
end
