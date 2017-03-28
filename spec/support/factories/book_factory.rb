FactoryGirl.define do
  factory :book do
    github_user "radar"
    github_repo "markdown_book_test"
    title "Markdown Book Test"
    format "markdown"
  end
end
