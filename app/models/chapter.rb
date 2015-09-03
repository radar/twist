require 'markdown_renderer'

class Chapter < ActiveRecord::Base

  # Provides an accessor to get to the git repository where the chapter is contained
  attr_accessor :git
  
  attr_accessor :footnote_count
  attr_accessor :section_count
  attr_accessor :image_count
  attr_accessor :listing_count

  belongs_to :book

  has_many :elements, -> { order("id ASC") }
  has_many :images
  has_many :notes, through: :elements

  scope :frontmatter, -> { where(part: "frontmatter") }
  scope :mainmatter, -> { where(part: "mainmatter") }
  scope :backmatter, -> { where(part: "backmatter") }

  after_save :expire_cache
  
  # Defaults footnote_count to something.
  # Would use attr_accessor_with_default if it wasn't deprecated.
  def footnote_count
    @footnote_count ||= 0
  end
  
  # Default image count to 0, increments when we call process_figure! in Processor
  def image_count
    @image_count ||= 0
  end

  # Default listing count to 0, increments when we call process_example! in
  # Processor
  def listing_count
    @listing_count ||= 0
  end
  
  # Used for correctly counting + labelling the sections.
  # Works with the within_section method contained in the Processor module.
  # 
  # Let's assume we're processing the first chapter of a book
  # For the first section, this variable will become:
  # [1, 1]
  # Next section:
  # [1, 1]
  # A sub-section of that section:
  # [1, 1, 1]
  # Then the next top-level section would be:
  # [1, 2]
  def section_count
    @section_count ||= [position, 0]
  end

  def self.process!(book, part, git, file, position)
    ext = File.extname(file)
    if %w(.markdown .md).include?(ext)
      process_markdown!(book, part, git, file, position)
    else
      raise "Unknown chapter format!"
    end
  end

  def self.process_markdown!(book, part, git, file, position)
    chapter = book.chapters.find_or_initialize_by(file_name: file)
    chapter.part = part
    chapter.git = git
    chapter.elements.delete_all
    chapter.images.delete_all
    chapter.position = position

    html = chapter.to_html
    chapter.title = html.css("h1").text
    chapter.permalink = chapter.title.parameterize
    elements = html.css("body > *")
    elements.each { |element| Element.process!(chapter, element) }
    chapter.save
  end

  def to_html 
    markdown = File.read(File.join(book.path, file_name))
    renderer = Redcarpet::Markdown.new(MarkdownRenderer, :fenced_code_blocks => true)
    html = Nokogiri::HTML(renderer.render(markdown))
  end

  def to_param
    permalink
  end

  def expire_cache
    Rails.cache.delete_matched("*chapters/#{id}")
  end

end
