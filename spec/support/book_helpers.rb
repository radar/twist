module BookHelpers
  def create_book!
    git = Git.new("radar", "rails3book_test")
    Resque.remove_queue("normal") # TODO: is there a better way than just putting this *everywhere*?
    # Nuke the repo, start afresh.
    FileUtils.rm_r(git.path)
    git.update!

    @book = Book.create(:title => "Rails 3 in Action", 
                        :path => "http://github.com/radar/rails3book_test")
    @book.path = git.path
    run_resque_job!
    @book.reload
  end
end

RSpec.configure do |c|
  c.include BookHelpers
end