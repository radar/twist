require 'rails_helper'

describe AsciidocBookWorker do
  context "with test book" do
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
      pending "Fill out titles for other chapters"
    end
  end

  context "with Rails 4 in Action" do
    let(:book) do
      Book.create(
        title: "Rails 4 in Action",
        github_user: "radar",
        github_repo: "rails_4_in_action"
      )
    end

    it "can process the book" do
      AsciidocBookWorker.new.perform(book.id)

      frontmatter_titles = book.chapters.frontmatter.map(&:title)
      expect(frontmatter_titles).to eq(["Preface / Introduction"])
    end
  end
end
