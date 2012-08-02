class Chapter
  include Mongoid::Document
  field :position, :type => Integer
  field :title, :type => String
  field :xml_id, :type => String
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
    # Read the XML, parse it with XSLT which will convert it into lovely HTML
    xml = Nokogiri::XML(File.read(git.path + file))
    xslt = Nokogiri::XSLT(File.read(Rails.root + 'lib/chapter.xslt'))
    parsed_doc = xslt.transform(xml)
    
    chapter = book.chapters.find_or_initialize_by(xml_id: xml.xpath("chapter").first["id"])
    chapter.git = git
    chapter.elements = [] # Clear the elements, begin anew.
    chapter.title = xml.xpath("chapter/title").text
    if chapter.new_record?
      # TODO: This needs to be fixed to use the chapter's position within the book, as that may change
      # We cannot rely on the ordering to stay the same.
      chapter.position = book.chapters.count + 1
    end

    elements = parsed_doc.css("div.chapter > *")
    # Why do we have to pass in the Chapter object here? Surely it can know it.
    # In ActiveRecord there is an @association.owner object which would return it.
    elements.each { |element| Element.process!(chapter, element) }
    book.save
    chapter.save_figure_attachments!
    chapter
  end
  
  def to_param
    position.to_s
  end
  
  def xml_id
    self["xml_id"]
  end

  def save_figure_attachments!
    self.figures.each { |figure| figure.save_attachment! }
  end

  def expire_cache
    Rails.cache.delete_matched("*chapters/#{id}")
  end

end
