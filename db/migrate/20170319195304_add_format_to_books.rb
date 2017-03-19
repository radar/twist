class AddFormatToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :format, :string
  end
end
