class AddPlanIdToAccounts < ActiveRecord::Migration
  def change
    add_reference :accounts, :plan, index: true, foreign_key: true
  end
end
