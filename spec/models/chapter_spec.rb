require 'spec_helper'

describe Chapter do
  let(:git) { Git.new("radar", "rails3book_test") }
  let(:book) { Factory.create(:book) }

  before do
    # Nuke the repo, start afresh.
    FileUtils.rm_r(git.path)
    git.update!
    book.path = (Rails.root + "repos/radar/rails3book_test").to_s
  end

  it "processes a chapter" do
    Chapter.process!(book, git, "ch01/ch01.xml")
    chapter = book.chapters.first
    chapter.title.should == "Ruby on Rails, the framework"
    chapter.xml_id.should == "ch01_1"
    chapter.elements.first.tag.should == "p"
    sections = chapter.elements.select { |e| e.tag == "section" }
    sections.map(&:title).should == ["What is Ruby on Rails?",
                                     "Benefits",
                                     "Common Terms",
                                     "Rails in the wild",
                                     "Developing your first application",
                                     "Installing Rails",
                                     "Generating an application",
                                     "Starting the application",
                                     "Scaffolding",
                                     "Migrations",
                                     "Viewing & creating purchases",
                                     "Validations",
                                     "Showing off",
                                     "Routing",
                                     "Updating",
                                     "Deleting",
                                     "Summary"]
    chapter.figures.count.should == 13
    chapter.figures.first.filename.should == "ch01/app.jpg"
  end

  it "updates a chapter" do
    Chapter.process!(book, git, "ch01/ch01.xml")
    chapter = book.chapters.first
    chapter.title.should == "Ruby on Rails, the framework"
    Dir.chdir(git.path) do
      doc = Nokogiri::XML(File.read("ch01/ch01.xml"))
      # Replace first paragraph's content with simply "Hello world!"
      doc.css("#ch01_3").first.content = "Hello world!"
      File.open("ch01/ch01.xml", "w+") do |f|
        f.write(doc.to_xml)
      end
    end

    # Re-process the chapter
    chapter = Chapter.process!(book, git, "ch01/ch01.xml")
    book.chapters.count.should == 1
    element = chapter.elements.first
    element.content.should == "<p id=\"ch01_3\">Hello world!</p>"
  end
end
