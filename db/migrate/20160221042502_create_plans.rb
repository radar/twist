class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.integer :amount
      t.string :stripe_id

      t.timestamps null: false
    end
  end
end
