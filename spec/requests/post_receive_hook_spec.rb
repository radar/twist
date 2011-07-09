require 'spec_helper'

describe 'post receive hook' do
  let(:book) { Factory(:book) }
  
  it "can be triggered" do
    assert !book.processing?
    visit receive_book_path(book)
    book.reload
    assert book.processing?
  end

  it "updates a book with added file"
  it "updates a book with modified file"
  it "updates a book with deleted file"
end