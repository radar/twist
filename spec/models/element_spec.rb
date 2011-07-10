require 'spec_helper'

describe Element do  
  context "processing" do
    let(:chapter) { Factory(:chapter) }

    def nokogiri(string, selector)
      Nokogiri::XML(string).xpath(selector).first
    end

    it "para within a chapter" do
      xml = nokogiri("<para id='ch01_1'>Hello world!</para>", "para")
      element = chapter.elements.process_para!(xml)
      element.identifier.should == 'ch01_1'
      element.content.should == "Hello world!"
      element.tag.should == "para"
    end
    
    it "para within a section"
    
    it "bare section" do
      xml = nokogiri("<section id='ch01_1'><title>Hello world!</title></section>", "section")
      element = chapter.elements.process_section!(xml)
      element.identifier.should == 'ch01_1'
      element.tag.should == "section"

      section = Section.first
      section.title.should == "Hello world!"
      section.identifier.should == "ch01_1"
    end
    
    it "itemized list" do
      string = <<-EOS
<itemizedlist id="ch01_124">
  <listitem id="ch01_125"><para id="ch01_126">Ruby</para></listitem>
  <listitem id="ch01_127"><para id="ch01_128">RubyGems</para></listitem>
  <listitem id="ch01_129"><para id="ch01_130">Rails</para></listitem>
</itemizedlist>
      EOS
      xml = nokogiri(string, "itemizedlist")
      element = chapter.elements.process_itemizedlist!(xml)
      element.identifier.should == "ch01_124"
      element.tag.should == "itemizedlist"
      
      element.children.count.should == 3
      assert element.children.all? { |e| e.tag == "listitem" }
    end
  end
  
  context "objects" do
    let(:element) { Factory(:element) }
    
    it "updates the versions table when updated" do
      element.versions.count.should == 0
      element.update_attributes(:content => "Hello everyone!")
      element.versions.count.should == 1

      element.current_version.should == 2
      version = element.versions.first
      version.content.should == "Hello world!"
    end
  end
end
