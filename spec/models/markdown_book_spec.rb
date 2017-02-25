require "rails_helper"

describe MarkdownBook do
  let(:book) do
    Book.create(
      title: "Markdown Book Test",
      github_user: "radar",
      github_repo: "markdown_book_test"
    )
  end

  subject { MarkdownBook.new(book) }

  it "processes a Book.txt file" do
    manifest = subject.process_manifest

    expect(manifest[:frontmatter]).to eq(["introduction.markdown"])
    expect(manifest[:mainmatter]).to eq([
      "chapter_1/chapter_1.markdown",
      "chapter_2/chapter_2.markdown"
    ])
    expect(manifest[:backmatter]).to eq(["appendix.markdown"])
  end
end
