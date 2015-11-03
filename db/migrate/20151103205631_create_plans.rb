class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.float :price
      t.string :braintree_id

      t.timestamps null: false
    end
  end
end
