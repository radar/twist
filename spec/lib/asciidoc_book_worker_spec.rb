require 'rails_helper'

describe AsciidocBookWorker do
  let(:book) do
    Book.create(
      title: "AsciiDoc Book Test",
      github_user: "radar",
      github_repo: "asciidoc_book_test"
    )
  end

  it "can process the book" do
    AsciidocBookWorker.new.perform(book.id)

    frontmatter_titles = book.chapters.frontmatter.map(&:title)
    expect(frontmatter_titles).to eq(["Preface / Introduction"])
  end
end
