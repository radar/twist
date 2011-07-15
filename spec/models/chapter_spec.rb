require 'spec_helper'

describe Chapter do
  let(:git) { Git.new("radar", "rails3book_test") }
  let(:book) { Factory(:book) }

  before do
    # Nuke the repo, start afresh.
    FileUtils.rm_r(git.path)
    git.update!
  end

  it "processes a chapter" do
    book.chapters.process!(git, "ch01/ch01.xml")
    chapter = book.chapters.first
    chapter.title.should == "Ruby on Rails, the framework"
    chapter.identifier.should == "ch01_1"
    chapter.elements.first.tag.should == "p"
    chapter.sections.map(&:title).should == ["What is Ruby on Rails?", 
                                             "Developing your first application",
                                             "Summary"]
  end

  it "updates a chapter" do
    # Create initial version of chapter's elements
    book.chapters.process!(git, "ch01/ch01.xml")
  
    # Alter first paragraph's text to contain new text
    chapter_file = git.path + "ch01/ch01.xml"
    chapter_xml = Nokogiri::XML(File.read(chapter_file))
    first_paragraph = chapter_xml.css("p#ch01_3")
    first_paragraph.content = "Hello world!"
    File.open(chapter_file, "w+") do |f|
      f.write(chapter_xml.to_xml)
    end
    
    book.chapters.process!(git, "ch01/ch01.xml")
    book.chapters.count.should == 1
    element = chapter.elements.first
    element.id.should == "ch01_3"
    element.versions.count.should == 2
  end
end