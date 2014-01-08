require 'spec_helper'

describe Chapter do
  let(:git) { Git.new("radar", "markdown_book_test") }
  let(:book) { FactoryGirl.create(:book) }

  before do
    # Nuke the repo, start afresh.
    FileUtils.rm_r(git.path)
    git.update!
    book.path = 'spec/fixtures/repos/radar/markdown_book_test'
  end

  it "processes a chapter" do
    Chapter.process!(book, git, "chapter_1/chapter_1.markdown")
    chapter = book.chapters.first
    chapter.title.should == "In the beginning"
    chapter.elements.first.tag.should == "p"

    sections = chapter.elements.select { |e| e.tag == "h2" }
    sections.map! { |s| Nokogiri::HTML(s.content).text }
    sections.should == ["This is a new section"]
    chapter.figures.count.should == 1
    chapter.figures.first.filename.should == "images/chapter_1/1.png"
    expect(chapter.figures.first.figure).not_to be_nil
    expect(chapter.elements.select { |e| e.tag == "img" }).not_to be_empty
  end
end
