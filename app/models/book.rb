class Book
  include Mongoid::Document
  field :user_id, :type => Integer
  field :path, :type => String
  field :title, :type => String
  field :blurb, :type => String
  field :permalink, :type => String
  field :current_commit, :type => String
  field :just_added, :type => Boolean, :default => true
  field :processing, :type => Boolean, :default => false
  field :notes_count, :type => Integer, :default => 0
  
  embeds_many :chapters
  
  @queue = "normal"
  before_create :set_permalink
  after_create :enqueue
  
  def self.perform(id)
    book = Book.find(id)
    # TODO: determine if path is HTTP || Git
    # TODO: determine if path is public
    user, repo = book.path.split("/")[-2, 2]
    git = Git.new(user, repo)
    book.path = git.path.to_s
    current_commit = git.current_commit
    git.update!

    # Use instance variable to make it bubble up out of the `chdir` block
    if book.just_added?
      Dir.chdir(git.path) do
        @changed_files = Dir["**/*.xml"]
      end
    else
      @changed_files = git.changed_files(current_commit)
    end

    @changed_files.grep(/ch\d+\/ch\d+.xml$/).sort.each do |file|
      Chapter.process!(book, git, file)
    end

    # When done, update the book with the current commit as a point of reference
    book.current_commit = git.current_commit
    book.processing = false
    book.just_added = false
    book.save
  end
  
  def notes
    chapters.map(&:notes).flatten
  end
  
  def to_param
    permalink
  end

  def enqueue
    Resque.enqueue(self.class, self.id)
    self.processing = true
    self.save!
  end
  
  def set_permalink
    self.permalink = title.parameterize
  end
end
