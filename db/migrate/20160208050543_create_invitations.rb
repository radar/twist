class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :email
      t.references :account, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
