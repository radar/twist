class AddCaptionToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :caption, :string
  end
end
