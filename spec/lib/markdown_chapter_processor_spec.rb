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
  end
end
