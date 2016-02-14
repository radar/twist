require 'rails_helper'

describe Chapter do
  let(:git) { Git.new("radar", "markdown_book_test") }
  let(:book) { FactoryGirl.create(:book) }

  before do
    FileUtils.rm_r(git.path)
    git.update!
    book.path = 'spec/fixtures/repos/radar/markdown_book_test'
  end

  it "can process markdown" do
    chapter = book.chapters.find_or_create_by(
      file_name: "chapter_1/chapter_1.markdown",
      part: "mainmatter"
    )

    expect do
      chapter.process!
    end.not_to raise_error
  end

  context "updating an existing chapter" do
    let(:chapter) do
      book.chapters.create!(
        title: "Introduction",
        file_name: "chapter_1/chapter_1.markdown"
      )
    end

    let!(:element_1) do
      element = chapter.elements.create
      element.notes.create
      element
    end

    let!(:element_2) do
      chapter.elements.create
    end

    it "keeps elements with notes" do
      chapter.process!
      chapter.reload

      expect { element_1.reload }.not_to raise_error
      expect { element_2.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context "navigation" do
    context "chapter 1" do
      let(:chapter) do
        book.chapters.find_or_create_by(
          file_name: "chapter_1/chapter_1.markdown",
          position: 1,
          part: "mainmatter"
        )
      end

      it "links back to only chapter in previous part" do
        introduction = book.chapters.create(
          title: "Introduction",
          position: 1,
          part: "frontmatter"
        )

        expect(chapter.previous_chapter).to eq(introduction)
      end

      it "links back to highest positioned chapter in previous part" do
        introduction = book.chapters.create(
          title: "Introduction",
          position: 1,
          part: "frontmatter"
        )

        foreword = book.chapters.create(
          title: "Introduction",
          position: 2,
          part: "frontmatter"
        )

        expect(chapter.previous_chapter).to eq(foreword)
      end


      it "links to next chapter in same part" do
        chapter_2 = book.chapters.create(
          title: "Chapter 2",
          position: 2,
          part: "mainmatter"
        )

        expect(chapter.next_chapter).to eq(chapter_2)
      end
    end

    context "last chapter of part" do
      let!(:chapter_1) do
        book.chapters.find_or_create_by(
          file_name: "chapter_1/chapter_1.markdown",
          position: 1,
          part: "mainmatter"
        )
      end

      let!(:chapter_2) do
        book.chapters.find_or_create_by(
          file_name: "chapter_2/chapter_2.markdown",
          position: 2,
          part: "mainmatter"
        )
      end

      it "links back to previous chapter" do
        expect(chapter_2.previous_chapter).to eq(chapter_1)
      end

      it "links to first chapter in next part" do
        appendix_a = book.chapters.create(
          title: "Appendix A",
          position: 1,
          part: "backmatter"
        )

        appendix_b = book.chapters.create(
          title: "Appendix B",
          position: 2,
          part: "backmatter"
        )

        expect(chapter_2.next_chapter).to eq(appendix_a)
      end
    end
  end
end
