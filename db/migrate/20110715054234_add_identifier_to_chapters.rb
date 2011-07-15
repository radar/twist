class AddIdentifierToChapters < ActiveRecord::Migration
  def change
    add_column :chapters, :identifier, :string
  end
end
