class CreateSubscriptionEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :subscription_events do |t|
      t.references :account, foreign_key: true
      t.string :type
      t.jsonb :data

      t.datetime :created_at
    end
  end
end
