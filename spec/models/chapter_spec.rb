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
    book.chapters << Chapter.process!(git, "ch01/ch01.xml")
    chapter = book.chapters.first
    chapter.title.should == "Ruby on Rails, the framework"
    chapter.identifier.should == "ch01_1"
    chapter.elements.first.tag.should == "p"
    sections = chapter.elements.select { |e| e.tag == "section" }
    sections.map(&:title).should == ["What is Ruby on Rails?", 
                                     "Developing your first application",
                                     "Summary"]
  end

  it "updates a chapter"
end