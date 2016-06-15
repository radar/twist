class CreatePlans < ActiveRecord::Migration[5.0]
  def change
    create_table :plans do |t|
      t.string :name
      t.integer :amount
      t.string :stripe_id

      t.timestamps
    end
  end
end
