class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :email
      t.integer :account_id

      t.timestamps null: false
    end
  end
end
