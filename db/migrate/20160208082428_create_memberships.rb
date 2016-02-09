class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :account, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
