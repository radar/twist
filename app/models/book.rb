class Book < ActiveRecord::Base
  @queue = "normal"
  after_create :enqueue
  
  has_many :chapters do
    # This method will process the chapters, but needs to be defined on the association as that's how it's called
    def process!(git, file)
      xml = Nokogiri::XML(File.read(git.path + file))
      create!(:title => xml.xpath("chapter/title").text)
    end
  end

  def enqueue
    Resque.enqueue(self.class, self.id)
  end
  
  def self.perform(id)
    book = Book.find(id)
    # TODO: determine if path is HTTP || Git
    # TODO: determine if path is public
    user, repo = book.path.split("/")[-2, 2]
    git = Git.new(user, repo)
    current_commit = git.current_commit
    git.update!

    git.changed_files(current_commit).grep(/ch\d+\/ch\d+.xml/).each do |file|
      book.chapters.process!(git, file)
    end

    # When done, update the book with the current commit as a point of reference
    book.current_commit = git.current_commit
    book.save
  end
end
