module BookHelpers
  def create_book!
    git = Git.new("radar", "markdown_book_test")
    # Nuke the repo, start afresh.
    FileUtils.rm_rf(git.path)
    git.update!

    book = Book.create(:title => "Markdown Book Test", 
                        :path => "http://github.com/radar/markdown_book_test")
    book.path = git.path
    # Run the Sidekiq job ourselves
    BookWorker.new.perform(book.id)
    book.reload
  end
end

RSpec.configure do |c|
  c.include BookHelpers
end
