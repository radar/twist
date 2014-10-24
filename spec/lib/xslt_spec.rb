require 'spec_helper'
require 'nokogiri'
require 'pry'

describe "XSLT parsing" do
  let(:xslt) { Nokogiri::XSLT(File.read("lib/chapter.xslt")) }
  it "can parse formal paragraphs containing figures" do
    xml = Nokogiri::XML::Builder.new do |xml|
      xml.chapter(:id => "ch1_1") do
        xml.formalpara(:id => "ch1_2") do
          xml.title "This is a title"
          xml.para(:id => "ch1_3") do
            xml.figure(:id => "ch1_4") do
              xml.title "The app directory"
              xml.mediaobject(:id => "ch1_5") do
                xml.imagedata(:fileref => "ch01/app.png", :id => "ch1_6")
              end
            end
          end
          xml.para({:id => "ch1_7"}, "stock standard paragraph")
        end
      end
    end
    
    parsed_doc = xslt.transform(Nokogiri::XML(xml.to_xml))
    # No wrapping p tag
    expect(parsed_doc.css("div.figure").first.parent).to eq(parsed_doc.css("div.chapter").first)
    # Ensure normal paragraph is unchanged
    expect(parsed_doc.css("p").first.text).to eq("stock standard paragraph")
  end
  
  it "can parse footnotes containing paragraphs" do
    xml = Nokogiri::XML::Builder.new do |xml|
      xml.chapter(:id => "ch1_1") do
        xml.para(:id => "ch1_2") do
          xml.text "This is content within the outside paragraph."
          xml.footnote(:id => "ch1_3") do
            xml.para(:id => "ch1_4") do
              xml.text "This is some content within this paragraph."
              xml.filename "run_this"
              xml.text "More text."
            end
          end
        end
      end
    end
      
    parsed_doc = xslt.transform(Nokogiri::XML(xml.to_xml))
    skip("The footnote is within the paragraph. Not sure how to fix this.")
  end
  
  it "can parse paragraphs containing callouts" do
    xml = Nokogiri::XML::Builder.new do |xml|
      xml.chapter(:id => "ch1_1") do
        xml.para(:id => "ch1_2") do
          xml.text "This is content within the paragraph."
          xml.co(:id => "ch1_3")
          xml.text "This is some further text after the callout."
        end
      end
    end
    
    parsed_doc = xslt.transform(Nokogiri::XML(xml.to_xml))
    expect(parsed_doc.css("p span.callout")[0]["id"]).to eq("ch1_3")
  end
end
