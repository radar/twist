class AddPositionToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :position, :integer
  end
end
