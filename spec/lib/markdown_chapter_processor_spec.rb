require "rails_helper"

describe MarkdownChapterProcessor do
  let(:book) { create_markdown_book! }

  subject do
    MarkdownChapterProcessor.new(
      book,
      "chapter_1/chapter_1.markdown",
      "mainmatter",
      1
    )
  end

  it "can process a chapter" do
    chapter = subject.process
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
