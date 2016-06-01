class AddBooksAllowedToPlans < ActiveRecord::Migration[5.0]
  def change
    add_column :plans, :books_allowed, :integer
  end
end
