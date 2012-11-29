require 'markdown_renderer'

class Chapter
  include Mongoid::Document
  field :position, :type => Integer
  field :title, :type => String
  field :file_name, :type => String
  
  embedded_in :book
  embeds_many :elements
  embeds_many :figures
  embeds_many :notes

  after_save :expire_cache

  # Provides an accessor to get to the git repository where the chapter is contained
  attr_accessor :git
  
  attr_accessor :footnote_count
  attr_accessor :section_count
  attr_accessor :figure_count
  attr_accessor :listing_count
  
  # Defaults footnote_count to something.
  # Would use attr_accessor_with_default if it wasn't deprecated.
  def footnote_count
    @footnote_count ||= 0
  end
  
  # Default figure count to 0, increments when we call process_figure! in Processor
  def figure_count
    @figure_count ||= 0
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

  def self.process!(book, git, file)
    ext = File.extname(file)
    if %w(.markdown .md).include?(ext)
      process_markdown!(book, git,file)
    else
      raise "Unknown chapter format!"
    end
  end

  def self.process_markdown!(book, git, file)
    chapter = book.chapters.find_or_initialize_by(file_name: file)
    chapter.git = git
    chapter.elements = []
    chapter.position = book.manifest.index(file) + 1

    html = chapter.to_html
    chapter.title = html.css("h1").text
    elements = html.css("body > *")
    elements.each { |element| Element.process!(chapter, element) }
    book.save
    chapter.save_figure_attachments!
    chapter
  end

  def to_html 
    markdown = File.read(File.join(book.path, file_name))
    renderer = Redcarpet::Markdown.new(MarkdownRenderer, :fenced_code_blocks => true)
    html = Nokogiri::HTML(renderer.render(markdown))
  end


  def to_param
    position.to_s
  end

  def save_figure_attachments!
    self.figures.each { |figure| figure.save_attachment! }
  end

  def expire_cache
    Rails.cache.delete_matched("*chapters/#{id}")
  end

end
