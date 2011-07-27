require 'spec_helper'

describe "notes" do
  let(:user) { create_user! }
  before do
    create_book!
    actually_sign_in_as(user)
  end
    
  it "can add a new note to a paragraph", :js => true do
    visit book_chapter_path(@book, @book.chapters.first)
    page!
  end
end