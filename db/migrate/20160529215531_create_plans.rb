class CreatePlans < ActiveRecord::Migration[5.0]
  def change
    create_table :plans do |t|
      t.string :name
      t.float :price
      t.string :braintree_id

      t.timestamps
    end
  end
end
