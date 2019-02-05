require 'rails_helper'

describe Chapter do
  let(:git) { Git.new("radar", "markdown_book_test") }
  let(:book) { FactoryBot.create(:book) }
  let(:chapter) do
    book.chapters.find_or_create_by(
      file_name: "chapter_1/chapter_1.markdown",
      part: "mainmatter"
    )
  end

  before do
    # Nuke the repo, start afresh.
    FileUtils.rm_rf(git.path)
    git.update!
    book.path = 'spec/fixtures/repos/radar/markdown_book_test'
  end

  it "processes a chapter" do
    chapter.process!
    chapter = book.chapters.first
    expect(chapter.title).to eq("In the beginning")
    expect(chapter.elements.first.tag).to eq("p")

    sections = chapter.elements.select { |e| e.tag == "h2" }
    sections.map! { |s| Nokogiri::HTML(s.content).text }
    expect(sections).to eq(["This is a new section"])
    expect(chapter.images.count).to eq(1)
    expect(chapter.images.first.filename).to eq("images/chapter_1/1.png")
    expect(chapter.images.first.image).not_to be_nil
    expect(chapter.elements.select { |e| e.tag == "img" }).not_to be_empty
  end
end
