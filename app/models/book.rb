class Book < ActiveRecord::Base

  has_many :chapters
  before_create :set_permalink

  def self.find_by_permalink(permalink)
    find_by(permalink: permalink, hidden: false)
  end

  def process_manifest(manifest)
    parts = Hash.new { |h, k| h[k] = [] }
    part = :mainmatter
    manifest.each do |file|
      case file
      when /frontmatter/
        part = :frontmatter
      when /mainmatter/
        part = :mainmatter
      when /backmatter/
        part = :backmatter
      else
        parts[part] << file
      end
    end

    parts
  end

  def manifest(&block)
    filename = "Book.txt"
    Dir.chdir(path) do
      if File.exist?(filename)
        files = File.read(filename).split("\n")
        if block_given?
          yield(files)
        else
          files
        end
      else
        raise "Couldn't find Book.txt"
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
