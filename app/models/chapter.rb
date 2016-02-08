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

  scope :ordered, -> { order("position ASC") }
  scope :frontmatter, -> { ordered.where(part: "frontmatter") }
  scope :mainmatter, -> { ordered.where(part: "mainmatter") }
  scope :backmatter, -> { ordered.where(part: "backmatter") }

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

  def process!
    # Keep any elements that have notes, ditch the rest
    elements.where("notes_count > 0").update_all(old: true)
    elements.where("notes_count = 0").delete_all

    images.delete_all

    html = to_html
    self.title = html.css("h1").text
    self.permalink = title.parameterize
    elements = html.css("body > *")
    elements.each { |element| Element.process!(self, element) }
    save
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
