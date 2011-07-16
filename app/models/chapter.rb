class Chapter
  include Mongoid::Document
  field :position, :type => Integer
  field :title, :type => String
  field :identifier, :type => String
  
  embedded_in :book
  embeds_many :elements
  
  attr_accessor :footnote_count
  
  # Defaults footnote_count to something.
  # Would use attr_accessor_with_default if it wasn't deprecated.
  def footnote_count
    @footnote_count ||= 0
  end
  
  def self.process!(git, file)
    # Read the XML, parse it with XSLT which will convert it into lovely HTML
    xml = Nokogiri::XML(File.read(git.path + file))
    xslt = Nokogiri::XSLT(File.read(Rails.root + 'lib/chapter.xslt'))
    parsed_doc = xslt.transform(xml)
    
    # chapter = find_or_initialize_by_identifier(xml.xpath("chapter").first["id"])
    chapter = new(:identifier => xml.xpath("chapter").first["id"])
    chapter.title = xml.xpath("chapter/title").text
    chapter.position = 1 # TODO: un "fix"

    elements = parsed_doc.css("div.chapter > *")
    # Why do we have to pass in the Chapter object here? Surely it can know it.
    # In ActiveRecord there is an @association.owner object which would return it.
    elements.each { |element| chapter.elements << Element.process!(chapter, element) }
    chapter
  end
end