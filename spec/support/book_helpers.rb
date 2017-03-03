module BookHelpers
  def create_markdown_book!(account=nil)
    git = Git.new("radar", "markdown_book_test")
    # Nuke the repo, start afresh.
    FileUtils.rm_rf(git.path)
    git.update!

    scope = account ? account.books : Book

    book = scope.create(
      title: "Markdown Book Test",
      github_user: "radar",
      github_repo: "markdown_book_test"
    )
  end

  def create_asciidoc_book!(account=nil)
    git = Git.new("radar", "asciidoc_book_test")
    # Nuke the repo, start afresh.
    FileUtils.rm_rf(git.path)
    git.update!

    scope = account ? account.books : Book

    book = scope.create(
      title: "Asciidoc Book Test",
      github_user: "radar",
      github_repo: "asciidoc_book_test"
    )
  end

  def process_book(book)
    # Run the Sidekiq job ourselves
    MarkdownBookWorker.new.perform(book.id)
    book.reload
  end
end

RSpec.configure do |c|
  c.include BookHelpers
end
