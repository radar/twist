class CreateSubscriptionEvents < ActiveRecord::Migration
  def change
    create_table :subscription_events do |t|
      t.references :account, index: true, foreign_key: true
      t.string :kind
      t.jsonb :details

      t.timestamps null: false
    end
  end
end
