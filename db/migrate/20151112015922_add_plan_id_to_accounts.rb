class AddPlanIdToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :plan_id, :integer
  end
end
