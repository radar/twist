class Book < ActiveRecord::Base
  @queue = "normal"
  after_create :enqueue
  
  has_many :chapters

  def enqueue
    Resque.enqueue(self.class, self.id)
  end
  
  def self.perform(id)
    book = Book.find(id)
    # TODO: determine if path is HTTP || Git
    # TODO: determine if path is public
    user, repo = book.path.split("/")[-2, 2]
    git = Git.new(user, repo)
    git.update!
    book.current_commit = git.current_commit
  end
end
