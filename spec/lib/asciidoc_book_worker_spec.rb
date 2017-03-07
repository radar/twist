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

      mainmatter_titles = book.chapters.mainmatter.map(&:title)
      expect(mainmatter_titles).to eq(["Chapter 1"])

      backmatter_titles = book.chapters.backmatter.map(&:title)
      expect(backmatter_titles).to eq(["Appendix A: The First Appendix"])
    end
  end

  context "with Rails 4 in Action", tag: :real_book do
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
      expect(frontmatter_titles).to eq(["Preface", "Acknowledgements", "About this book"])

      mainmatter_titles = book.chapters.mainmatter.map(&:title)
      expect(mainmatter_titles).to eq(
        [
          "Ruby on Rails, the framework",
          "Testing saves your bacon",
          "Developing a real Rails application",
          "Oh, CRUD!",
          "Nested resources",
          "Authentication",
          "Basic access control",
          "Fine-grained access control",
          "File uploading",
          "Tracking state",
          "Tagging",
          "Sending email",
          "Deployment",
          "Designing an API",
          "Rack-based applications"
        ]
      )

      backmatter_titles = book.chapters.backmatter.map(&:title)
      expect(backmatter_titles).to eq(["Appendix A: Installation Guide", "Appendix B: Why Rails?"])
    end
  end
end
