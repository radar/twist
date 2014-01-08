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
  field :hidden, :type => Boolean, :default => false
  
  embeds_many :chapters
  
  @queue = "normal"
  before_create :set_permalink

  def manifest(&block)
    Dir.chdir(path) do
      if File.exist?("manifest.txt")
        files = File.read("manifest.txt").split("\n")
        if block_given?
          yield(files)
        else
          files
        end
      else
        raise "Couldn't find manifest.txt"
      end
    end
  end

  def notes
    chapters.map(&:notes).flatten
  end

  def to_param
    permalink
  end

  def enqueue
    BookWorker.perform_async(id.to_s)
    self.processing = true
    self.save!
  end

  def set_permalink
    self.permalink = title.parameterize
  end
end
