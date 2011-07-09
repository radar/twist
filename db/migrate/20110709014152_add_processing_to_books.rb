class AddProcessingToBooks < ActiveRecord::Migration
  def change
    add_column :books, :processing, :boolean, :default => false
  end
end
