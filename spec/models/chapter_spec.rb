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
end
