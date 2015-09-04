class Book < ActiveRecord::Base

  has_many :chapters
  has_many :notes, through: :chapters
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
        unless file.strip.blank?
          parts[part] << file.strip
        end
      end
    end

    parts
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
