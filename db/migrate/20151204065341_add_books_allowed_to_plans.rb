class AddBooksAllowedToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :books_allowed, :integer
  end
end
