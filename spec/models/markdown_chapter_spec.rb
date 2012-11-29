require 'spec_helper'

describe Chapter do
  let(:git) { Git.new("radar", "markdown_book_test") }
  let(:book) { FactoryGirl.create(:book) }

  before do
    # Nuke the repo, start afresh.
    FileUtils.rm_r(git.path)
    git.update!
    book.path = (Rails.root + "repos/radar/markdown_book_test").to_s
  end

  it "processes a chapter" do
    Chapter.process!(book, git, "chapter_1/chapter_1.markdown")
    chapter = book.chapters.first
    chapter.title.should == "In the beginning"
    chapter.elements.first.tag.should == "p"

    pending
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
end
