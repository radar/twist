class Chapter < ActiveRecord::Base
  has_many :elements, :order => "id ASC", :as => :parent, :extend => Processor
  has_many :sections, :extend => SectionProcessor
  belongs_to :book

  class << self
    def process!(git, file)
      # Read the XML, parse it with XSLT which will convert it into lovely HTML
      xml = Nokogiri::XML(File.read(git.path + file))
      xslt = Nokogiri::XSLT(File.read(Rails.root + 'lib/chapter.xslt'))
      parsed_doc = xslt.transform(xml)
      
      chapter = create!(:title => xml.xpath("chapter/title").text,
                        :position => 1)
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
