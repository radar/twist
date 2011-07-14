class Chapter < ActiveRecord::Base
  has_many :elements, :order => "id ASC", :as => :parent, :extend => Processor
  has_many :sections, :extend => SectionProcessor
  belongs_to :book
  
  # Hack to work around chapter object "hopping" when processing, so we can keep footnote count of entire chapter
  cattr_accessor :current_chapter
  
  # used for counting the footnotes in a chapter when processing them
  attr_accessor :footnote_count

  class << self
    def process!(git, file)
      # Read the XML, parse it with XSLT which will convert it into lovely HTML
      xml = Nokogiri::XML(File.read(git.path + file))
      xslt = Nokogiri::XSLT(File.read(Rails.root + 'lib/chapter.xslt'))
      parsed_doc = xslt.transform(xml)
      
      chapter = create!(:title => xml.xpath("chapter/title").text,
                        :position => 1)
      # TODO: SO INCREDIBLY HACKY
      Chapter.current_chapter = chapter
      Chapter.current_chapter.footnote_count = 0
      elements = parsed_doc.css("div.chapter > *")
      elements.each { |element| chapter.elements.process!(element) }
    end
  end
  
  # Helper method to access current chapter. Mainly used for sections, but can be called on a chapter.
  def chapter
    self
  end
  
  def to_param
    position.to_s
  end
end
