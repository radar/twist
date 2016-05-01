class CreateSubscriptionEvents < ActiveRecord::Migration
  def change
    create_table :subscription_events do |t|
      t.references :account, index: true, foreign_key: true
      t.string :type
      t.jsonb :data

      t.datetime :created_at, null: false
    end
  end
end
