class RemoveJustAddedAndProcessingFromBooks < ActiveRecord::Migration[5.0]
  def change
    remove_column :books, :just_added
    remove_column :books, :processing
  end
end
