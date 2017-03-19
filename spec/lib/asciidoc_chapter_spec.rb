require "spec_helper"
require "asciidoc_chapter"

describe AsciidocChapter do
  context "process" do
    let(:book) do
      Book.create(
        title: "AsciiDoc Book Test",
        github_user: "radar",
        github_repo: "asciidoc_book_test",
        current_commit: "abc123"
      )
    end
    let(:element) { double('Element') }
    subject { AsciidocChapter.new(book, element, 0) }
    before { allow(subject).to receive(:title) { "Preface / Introduction"} }

    it "creates a new chapter for the book" do
      subject.process
      chapter = book.chapters.first
      expect(chapter.commit).to eq(book.current_commit)
    end
  end

  context "part" do
    let(:book) { double('Book') }
    let(:element) { double('Element') }
    subject { AsciidocChapter.new(book, element, 0) }
    context "when title has no prefix" do
      before { allow(subject).to receive(:title) { "Preface / Introduction"} }

      it "is frontmatter" do
        expect(subject.part).to eq("frontmatter")
      end
    end

    context "when the title has a number prefix" do
      before { allow(subject).to receive(:title) { "1. In the Beginning"} }

      it "is mainmatter" do
        expect(subject.part).to eq("mainmatter")
      end
    end

    context "when the title has an 'Appendix' prefix" do
      before { allow(subject).to receive(:title) { "Appendix A: In the Beginning"} }

      it "is backmatter" do
        expect(subject.part).to eq("backmatter")
      end
    end
  end
end
