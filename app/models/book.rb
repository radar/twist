class Book < ActiveRecord::Base

  has_many :chapters
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
