class AddTokenToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :token, :string
    add_index :invitations, :token
  end
end
