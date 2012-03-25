require 'spec_helper'

describe Element do
  let(:book) { Factory.create(:book) }
  let(:chapter) { book.chapters.create!(:title => "Testing", :position => 1) }
  
  before do
  end
  
  it "can process a footnote containing a paragraph which contains a filename correctly" do
    xml = Nokogiri::XML::Builder.new do |xml|
      xml.p(:id => "ch1_2") do
        xml.text "This is content within the outside paragraph."
        xml.span(:class => "footnote", :id => "ch1_3") do
          xml.text "This is some content within this paragraph."
          xml.span(:class => "command") do
            xml.text "run_this"
          end
          xml.text "More text."
        end
      end
    end
    
    puts xml.to_xml
    
    Element.process!(chapter, Nokogiri::XML(xml.to_xml).css("p").first)
    p chapter.elements.map(&:content)
  end
end
  
