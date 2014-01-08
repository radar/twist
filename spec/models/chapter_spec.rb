require 'spec_helper'

describe Chapter do
  let(:git) { Git.new("radar", "markdown_book_test") }
  let(:book) { FactoryGirl.create(:book) }

  before do
    FileUtils.rm_r(git.path)
    git.update!
    book.path = `bundle show markdown_book_test`.strip
  end

  it "can process markdown" do
    markdown_processing = lambda { Chapter.process_markdown!(book, git, "chapter_1/chapter_1.markdown") }
    markdown_processing.should_not raise_error
  end
end
