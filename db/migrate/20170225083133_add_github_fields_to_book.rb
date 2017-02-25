class AddGithubFieldsToBook < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :github_user, :string
    add_column :books, :github_repo, :string
  end
end
