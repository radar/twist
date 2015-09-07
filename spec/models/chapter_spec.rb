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
    expect do
      Chapter.process_markdown!(book, "mainmatter", git, "chapter_1/chapter_1.markdown", 1)
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
      Chapter.process_markdown!(book, "mainmatter", git, "chapter_1/chapter_1.markdown", 1)
      chapter.reload

      expect { element_1.reload }.not_to raise_error
      expect { element_2.reload }.to raise_error(ActiveRecord::RecordNotFound)

    end
  end
end
