class RemoveAccountIdFromInvitations < ActiveRecord::Migration[5.0]
  def change
    remove_column :invitations, :account_id
  end
end
